public with sharing class ReleaseGateModel {
    public class CallableError {
        public Integer code;
        public String message;

        /********************************************************************************************
         * @description Two argument constructor
         * @param  code An Integer representing the error code
         * @param  message A string representing the error message
         * @return A CallableError with all properties populated.
         ********************************************************************************************/
        public CallableError(Integer code, String message) {
            this.code = code;
            this.message = message;
        }
    }

    public virtual class CallableResult {
        public Boolean success;
        public CallableError error;

        /********************************************************************************************
         * @description Two argument constructor
         * @param  success A boolean representing if the call was successful or not
         * @param  error A CallableError representing the error in case the call was not successful
         * @return A CallableResult with all properties populated.
         ********************************************************************************************/
        public CallableResult(Boolean success, CallableError error) {
            this.success = success;
            this.error = error;
        }
    }

    public class GetReleaseGateActionResult extends CallableResult {
        public GetReleaseGateResult[] result;

        /*****************************************************************************************************************
         * @description Three argument constructor
         *****************************************************************************************************************/
        public GetReleaseGateActionResult(GetReleaseGateResult[] result, Boolean success, CallableError error) {
            super(success, error);
            this.result = result;
        }
    }

    public class GetReleaseGateResult {
        public ReleaseGateProduct product;
        public ReleaseGate[] gates;

        /*****************************************************************************************************************
         * @description Two argument constructor
         *****************************************************************************************************************/
        public GetReleaseGateResult(ReleaseGateProduct product, ReleaseGate[] gates) {
            this.product = product;
            this.gates = gates;
        }
    }

    public class ReleaseGateProduct {
        public String name;
        public String label;
        public String nextReleaseDate;

        /*****************************************************************************************************************
         * @description Three argument constructor
         *****************************************************************************************************************/
        public ReleaseGateProduct(String name, String label, String nextReleaseDate) {
            this.name = name;
            this.label = label;
            this.nextReleaseDate = nextReleaseDate;
        }
    }

    public class ReleaseGate {
        public String name;
        public String label;
        public String description;
        public Date releaseDate;
        public Date dueDate;
        public String dueDateInfoText;
        public DateTime activationDate;
        public ReleaseGateFeature[] items;
        public String status;

        /*****************************************************************************************************************
         * @description Nine argument constructor
         *****************************************************************************************************************/
        public ReleaseGate(
            String name,
            String label,
            String description,
            Date releaseDate,
            Date dueDate,
            String dueDateInfoText,
            Datetime activationDate,
            String status,
            List<ReleaseGateFeature> features
        ) {
            this.name = name;
            this.label = label;
            this.description = description;
            this.releaseDate = releaseDate;
            this.dueDate = dueDate;
            this.dueDateInfoText = dueDateInfoText;
            this.activationDate = activationDate;
            this.status = status;
            this.items = features;
        }
    }

    public class ReleaseGateFeature {
        public String name;
        public String label;
        public String description;
        public String helpLink;
        public String helpLinkLabel;

        /*****************************************************************************************************************
         * @description Five argument constructor
         *****************************************************************************************************************/
        public ReleaseGateFeature(
            String name,
            String label,
            String description,
            String helpLink,
            String helpLinkLabel
        ) {
            this.name = name;
            this.label = label;
            this.description = description;
            this.helpLink = helpLink;
            this.helpLinkLabel = helpLinkLabel;
        }
    }

    public class ActivateReleaseGateResult {
        public String productName;
        public String gateName;
        public String status;

        public ActivateReleaseGateResult(String productName, String gateName, String status) {
            this.productName = productName;
            this.gateName = gateName;
            this.status = status;
        }
    }

    public class ActivateReleaseGateActionResult extends CallableResult {
        public ActivateReleaseGateResult[] result;

        public ActivateReleaseGateActionResult(
            ActivateReleaseGateResult[] result,
            Boolean success,
            CallableError error
        ) {
            super(success, error);
            this.result = result;
        }
    }
}
