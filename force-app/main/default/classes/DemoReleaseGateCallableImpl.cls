/*
    Copyright (c) 2021, Salesforce.org
    All rights reserved.
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
    * Neither the name of Salesforce.org nor the names of
    its contributors may be used to endorse or promote products derived
    from this software without specific prior written permission.
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
*/
/**
 * @author Salesforce.org
 * @date 2021
 * @group Release gating
 * @group-content ../../ApexDocContent/EdaSettings.htm
 * @description Example release gate implementation
 * This class emulates an actual release gate.
 * The release gate state is stored in a contact record which is created when this gate is activated
 */
global with sharing class DemoReleaseGateCallableImpl implements Callable {
    public static final String GET_ACTION = 'releasegate.get';
    public static final String ACTIVATE_ACTION = 'releasegate.activate';
    public static final String VERSION_PARAMETER = 'version';
    public static final String PRODUCT_PARAMETER = 'product';
    public static final String GATE_PARAMETER = 'gate';
    public static final String MOCK_CONTACT_PREFIX = 'callableinteropdemo_';
    public static final String DEMO_PRODUCT_NAME = 'ExampleProduct1';

    /**
     * @description Get a list of products with release gates
     * @param  version Callable API version
     * @return         A list of products and release gates in json format
     */
    public String getReleaseGates(Decimal version) {
        //Create 2 release gates with the corresponding features
        List<ReleaseGateModel.GetReleaseGateResult> resultList = new List<ReleaseGateModel.GetReleaseGateResult>{
            new ReleaseGateModel.GetReleaseGateResult(
                new ReleaseGateModel.ReleaseGateProduct(DEMO_PRODUCT_NAME, 'Example Product One', ''),
                new List<ReleaseGateModel.ReleaseGate>{
                    new ReleaseGateModel.ReleaseGate(
                        'summer21',
                        'Summer \'21',
                        'Here\'s what\'s new in Summer \'21. See the documentation for instructions on setting up these features, and then activate the release.',
                        null,
                        Date.today().addMonths(3),
                        'On this date, we activate the current release on all sandboxes that are still on the previous release.',
                        null,
                        'inactive',
                        new List<ReleaseGateModel.ReleaseGateFeature>{
                            new ReleaseGateModel.ReleaseGateFeature(
                                'ExampleFeature1',
                                'Example Feature 1',
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                                'https://www.salesforce.com',
                                'See example feature 1'
                            ),
                            new ReleaseGateModel.ReleaseGateFeature(
                                'ExampleFeature2',
                                'Example Feature 2',
                                'Bibendum arcu vitae elementum curabitur. Vitae ultricies leo integer malesuada nunc. Donec ac odio tempor orci dapibus ultrices.',
                                'https://powerofus.force.com',
                                'See example feature 2'
                            ),
                            new ReleaseGateModel.ReleaseGateFeature(
                                'ExampleFeature3',
                                'Example Feature 3',
                                'Penatibus et magnis dis parturient montes nascetur ridiculus. Dolor sit amet consectetur adipiscing elit ut aliquam. Adipiscing elit duis tristique sollicitudin nibh sit amet. Lacus laoreet non curabitur gravida arcu ac tortor.',
                                'https://www.salesforce.com',
                                'See example feature 3'
                            )
                        }
                    ),
                    new ReleaseGateModel.ReleaseGate(
                        'spring21',
                        'Spring \'21',
                        'Spring \'21 is now activated for all orgs',
                        null,
                        Date.today().addMonths(6),
                        'On this date, we activate the current release on all sandboxes that are still on the previous release.',
                        Datetime.now().addMonths(-1),
                        'active',
                        new List<ReleaseGateModel.ReleaseGateFeature>{
                            new ReleaseGateModel.ReleaseGateFeature(
                                'flexscheduling',
                                'Flex Scheduling',
                                'Flexible scheduling is activated in all orgs. If you haven\'t already done so, configure location- and topic-based advising availability for your users.',
                                'https://powerofus.force.com/s/article/SAL-Set-Up-Location-Based-Advising-Availability',
                                'Set Up Location-Based Advising Availability'
                            ),
                            new ReleaseGateModel.ReleaseGateFeature(
                                'groupavailability',
                                'Group Availability',
                                'Group availability allows advisees to reserve a spot in a group advising appointment. Even if you\'re not using group availability yet, be sure you\'ve set up permissions on the Attendee Limit and Discoverable fields.',
                                'https://powerofus.force.com/s/article/SAL-Set-Up-Group-Availability',
                                'Set Up Group Advising Availability'
                            )
                        }
                    )
                }
            )
        };
        //Loading the activated state for 'summer21' the db
        this.loadReleaseGateStateFromDb(resultList[0].gates[0]);

        //Create a GetReleaseGateActionResult model
        ReleaseGateModel.GetReleaseGateActionResult releaseGateResultModel = new ReleaseGateModel.GetReleaseGateActionResult(
            resultList,
            true,
            null
        );
        //Serialize the model into a json string and return
        return JSON.serialize(releaseGateResultModel);
    }

    /**
     * @description Activate a release gate
     * @param  version     Callable API version
     * @param  productName Release gate product name
     * @param  gateName    Release gate name
     * @return             Activate release gate result in json format
     */
    public String activateReleaseGate(Decimal version, String productName, String gateName) {
        if (productName == DEMO_PRODUCT_NAME && gateName == 'summer21') {
            //We will create a contact to emulate gate activation
            //If a contact with the LastName == MOCK_CONTACT_PREFIX + gateName exists it means the gate is active
            String stateContactName = MOCK_CONTACT_PREFIX + gateName;
            List<Contact> stateContacts = [
                SELECT Id, CreatedDate, LastName
                FROM Contact
                WHERE LastName = :stateContactName
            ];
            if (stateContacts.isEmpty()) {
                //Activating the release gate
                Contact stateContact = new Contact();
                stateContact.LastName = stateContactName;
                insert stateContact;
            } else {
                //If the gate is already active return an error
                return JSON.serialize(this.createActivationErrorResult(400, 'The gate was already activated'));
            }
            String status = 'active';
            return JSON.serialize(
                new ReleaseGateModel.ActivateReleaseGateActionResult(
                    new List<ReleaseGateModel.ActivateReleaseGateResult>{
                        new ReleaseGateModel.ActivateReleaseGateResult(productName, gateName, status)
                    },
                    true,
                    null
                )
            );
        } else {
            //If an incorrect product or gate name was passed (which is highly unlikely) we will return a callable error
            return JSON.serialize(this.createActivationErrorResult(400, 'Incorrect product or gate name'));
        }
    }

    public Object call(String action, Map<String, Object> args) {
        System.debug('Executing callable action: ' + action);
        String result;
        if (action == GET_ACTION) {
            result = this.getReleaseGates((Decimal) args.get(VERSION_PARAMETER));
        } else if (action == ACTIVATE_ACTION) {
            result = this.activateReleaseGate(
                (Decimal) args.get(VERSION_PARAMETER),
                (String) args.get(PRODUCT_PARAMETER),
                (String) args.get(GATE_PARAMETER)
            );
        } else {
            throw new IllegalArgumentException('Method not implemented');
        }
        System.debug('Action finished, result: \r\n' + result);
        return result;
    }

    /**
     * @description Loads the release gate state from a contact record
     * @param  gate A release gate instance to load
     */
    private void loadReleaseGateStateFromDb(ReleaseGateModel.ReleaseGate gate) {
        //For our mock gates we store their states in contact records
        //The gate is active if the contact with the corresponding name exists in the Contact object
        String stateContactName = MOCK_CONTACT_PREFIX + gate.name;
        List<Contact> stateContacts = [
            SELECT Id, CreatedDate, LastName
            FROM Contact
            WHERE LastName = :stateContactName
        ];
        if (!stateContacts.isEmpty()) {
            gate.status = 'active';
            gate.activationDate = stateContacts[0].CreatedDate;
        }
    }

    /**
     * @description create an activation error result
     * @param  errorCode    An error code
     * @param  errorMessage An error message
     * @return              An ActivateReleaseGateActionResult instance
     */
    private ReleaseGateModel.ActivateReleaseGateActionResult createActivationErrorResult(
        Integer errorCode,
        String errorMessage
    ) {
        return new ReleaseGateModel.ActivateReleaseGateActionResult(
            null,
            false,
            new ReleaseGateModel.CallableError(errorCode, errorMessage)
        );
    }
}
