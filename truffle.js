const DEFAULT = {
    host: 'localhost',
    port: 9545,
    network_id: '*'
}

const GANACHE = {
    host: 'localhost',
    port: 7545,
    network_id: '*'
}

module.exports = {
    networks: {
        development: { 
            ...DEFAULT
        },
        ganache: {
            ...GANACHE
        }
    }
};
