/*
    Copyright (c) 2021, Salesforce.org
    All rights reserved.
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this List of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this List of conditions and the following disclaimer in the
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
 * @group EDA Setup
 * @group-content
 * @description A demo release gating class to simulate EDA release gates
 */
global with sharing class DemoReleaseGateCallableErrorImpl implements Callable {
    public static final String GET_ACTION = 'releasegate.get';
    public static final String ACTIVATE_ACTION = 'releasegate.activate';
    public static final String VERSION_PARAMETER = 'version';
    public static final String PRODUCT_PARAMETER = 'product';
    public static final String GATE_PARAMETER = 'gate';

    /**
     * @description Get a list of products with release gates
     * @param  version Callable API version
     * @return         A list of products and release gates in json format
     */
    public String getReleaseGates(Decimal version) {
        ReleaseGateModel.GetReleaseGateActionResult releaseGateResultModel;
        if (version == 13) {
            releaseGateResultModel = new ReleaseGateModel.GetReleaseGateActionResult(
                null,
                false,
                new ReleaseGateModel.CallableError(
                    400,
                    'Version 13 is unexpected here. The Callable class returned an error response'
                )
            );
        } else if (version == 0) {
            throw new IllegalArgumentException('This version is unexpected. The Callable class threw an exception');
        } else {
            List<ReleaseGateModel.GetReleaseGateResult> resultList = new List<ReleaseGateModel.GetReleaseGateResult>{
                new ReleaseGateModel.GetReleaseGateResult(
                    new ReleaseGateModel.ReleaseGateProduct('DemoErrorProduct2', 'Demo Error Product', 'January 2022'),
                    new List<ReleaseGateModel.ReleaseGate>{
                        new ReleaseGateModel.ReleaseGate(
                            'demoerror',
                            'Demo Error Release Gate',
                            'This release gate will return an error when activated',
                            null,
                            Date.today().addMonths(6),
                            'On this date, we activate the current release on all sandboxes that are still on the previous release.',
                            null,
                            'inactive',
                            new List<ReleaseGateModel.ReleaseGateFeature>{
                                new ReleaseGateModel.ReleaseGateFeature(
                                    'ExampleFeature1',
                                    'Example inactive feature 1',
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                                    'https://www.salesforce.com',
                                    'See example feature 1'
                                ),
                                new ReleaseGateModel.ReleaseGateFeature(
                                    'ExampleFeature2',
                                    'Example inactive feature 2',
                                    'Bibendum arcu vitae elementum curabitur. Vitae ultricies leo integer malesuada nunc. Donec ac odio tempor orci dapibus ultrices. Penatibus et magnis dis parturient montes nascetur ridiculus. Dolor sit amet consectetur adipiscing elit ut aliquam. Adipiscing elit duis tristique sollicitudin nibh sit amet. Lacus laoreet non curabitur gravida arcu ac tortor. Ullamcorper a lacus vestibulum sed arcu non odio.',
                                    'https://www.salesforce.com',
                                    'See example feature 2'
                                )
                            }
                        ),
                        new ReleaseGateModel.ReleaseGate(
                            'demoexception',
                            'Demo Exception Release Gate',
                            'This release gate will throw an exception when activated',
                            null,
                            Date.today().addMonths(6),
                            'On this date, we activate the current release on all sandboxes that are still on the previous release.',
                            null,
                            'inactive',
                            new List<ReleaseGateModel.ReleaseGateFeature>{
                                new ReleaseGateModel.ReleaseGateFeature(
                                    'ExampleFeature1',
                                    'Example inactive feature 1',
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                                    'https://www.salesforce.com',
                                    'See example feature 1'
                                ),
                                new ReleaseGateModel.ReleaseGateFeature(
                                    'ExampleFeature2',
                                    'Example inactive feature 2',
                                    'Bibendum arcu vitae elementum curabitur. Vitae ultricies leo integer malesuada nunc. Donec ac odio tempor orci dapibus ultrices. Penatibus et magnis dis parturient montes nascetur ridiculus. Dolor sit amet consectetur adipiscing elit ut aliquam. Adipiscing elit duis tristique sollicitudin nibh sit amet. Lacus laoreet non curabitur gravida arcu ac tortor. Ullamcorper a lacus vestibulum sed arcu non odio.',
                                    'https://www.salesforce.com',
                                    'See example feature 2'
                                )
                            }
                        )
                    }
                )
            };

            releaseGateResultModel = new ReleaseGateModel.GetReleaseGateActionResult(resultList, true, null);
        }
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
        if (gateName == 'demoerror') {
            return JSON.serialize(
                new ReleaseGateModel.ActivateReleaseGateActionResult(
                    null,
                    false,
                    new ReleaseGateModel.CallableError(
                        400,
                        'This release gate cannot be activated. This error was returned from the Callable class'
                    )
                )
            );
        } else {
            throw new IllegalArgumentException(
                'This release gate cannot be activated. The Callable class threw an exception'
            );
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
}
