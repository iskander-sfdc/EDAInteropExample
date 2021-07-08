global with sharing class DemoReleaseGateCallableImpl implements Callable {
    public static final string GET_ACTION = 'releasegate.get';
    public static final string ACTIVATE_ACTION = 'releasegate.activate';
    public DemoReleaseGateCallableImpl() {
    }

    public String getReleaseGates(Decimal version) {        
        System.debug('Retrieving release gates');
        System.debug('API version: ' + version);
        return '{' + '\r\n'+
            '"success":true,' + '\r\n'+
            '"result":[' + '\r\n'+
            '  {' + '\r\n'+
            '    "product":{' + '\r\n'+
            '      "name":"DemoCallable",' + '\r\n'+
            '      "label":"Demo Callable Product",' + '\r\n'+
            '      "nextReleaseDate":"2022-02-01"' + '\r\n'+
            '    },' + '\r\n'+
            '    "gates":[' + '\r\n'+
            '      {' + '\r\n'+
            '        "name":"summer21",' + '\r\n'+
            '        "label":"Summer\'21",' + '\r\n'+
            '        "description":"Here\'s what\'s new in Summer\'21 ...",' + '\r\n'+
            '        "releaseDate":"2021-07-01",' + '\r\n'+
            '        "dueDate":"2021-11-04",' + '\r\n'+
            '        "activationDate":"2021-11-03T00:00:00.000Z",' + '\r\n'+
            '        "items":[' + '\r\n'+
            '          {' + '\r\n'+
            '            "name":"FlexibleAdviseeSnapshot",' + '\r\n'+
            '            "label":"Flexible Advisee Snapshot",' + '\r\n'+
            '            "description":"We\'ve redesigned the Advisee snapshot ...",' + '\r\n'+
            '            "helpLink":"https://powerofus.force.com/s/article/SAL-Advisor-App-Snapshot-Contact",' + '\r\n'+
            '            "helpLinkLabel":"Set up the Advisee Snapshot and Contact Details"' + '\r\n'+
            '          }' + '\r\n'+
            '        ],' + '\r\n'+
            '        "status":"active"' + '\r\n'+
            '      }' + '\r\n'+
            '    ]' + '\r\n'+
            '  }' + '\r\n'+
            ']' + '\r\n'+
        '}';
    }

    public String activateReleaseGate(Decimal version, String productName, String gateName) {
        System.debug('Activating release gate');
        System.debug('API version: ' + version);
        System.debug('Product name: ' + productName);
        System.debug('Gate name: ' + gateName);
        return '{' + '\r\n'+
            '"success":true,' + '\r\n'+
            '"result":[' + '\r\n'+
            '  {' + '\r\n'+
            '    "productName":"DemoCallable",' + '\r\n'+
            '    "gateName":"summer21",' + '\r\n'+
            '    "status":"active"' + '\r\n'+
            '  }' + '\r\n'+
            ']' + '\r\n'+
        '}';
    }

    public Object call(String action, Map<String, Object> args) {
        System.debug('Execution callable action: ' + action);
        String result;
        if (action == GET_ACTION) {
            result = this.getReleaseGates((Decimal)args.get('version'));
        }
        else if (action == ACTIVATE_ACTION) {
            result = this.activateReleaseGate((Decimal)args.get('version'), (String)args.get('product'), (String)args.get('gate'));
        }
        else {
            throw new IllegalArgumentException('Method not implemented');
        }
        System.debug('Action finished, result: \r\n' + result);
        return result;
    }
}
