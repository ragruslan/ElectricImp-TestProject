class TableTestCase extends ImpTestCase {

    static CHECK_NUM = 3;

    _table = null;

    function setUp() {
        device.on("conditions.sent", function(data) {
            _table = data;
        }.bindenv(this));
    }

    function testTableFields() {
        local tests_done = 0;
        local myFunc = null;
        return Promise(function(resolve, reject) {
            myFunc = function() {
                if (_table == null) {
                    imp.wakeup(1.0, myFunc);
                } else if (("temperature" in _table) && ("humidity" in _table)) {
                    tests_done += 1;
                    this.info(_table);
                    this.info("Table is OK!");
                    _table = null;
                    if (tests_done == CHECK_NUM) {
                        resolve();
                    } else {
                        imp.wakeup(1.0, myFunc);
                    }
                } else {                    
                    this.info(_table);
                    this.info("WRONG Table!");                    
                    _table = null;
                    reject();
                }
            }.bindenv(this);
            imp.wakeup(1.0, myFunc);
        }.bindenv(this));
    }

}
