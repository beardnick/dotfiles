return require('telescope').register_extension({
    exports = {
        goimpl = require 'lang.go'.goimpl,
    },
})
