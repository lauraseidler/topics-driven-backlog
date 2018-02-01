/**
 * Generate all getter.
 *
 * @param {object} settings
 * @returns {function}
 */
export function all(settings) {
    if (settings.parent) {
        /**
         * Get a function to get all items of resource by parent ID.
         *
         * @param {object} state
         * @returns {function}
         */
        return function (state) {
            /**
             * Return data depending on parent ID.
             *
             * @param {int} parentId
             * @returns {array}
             */
            return function (parentId) {
                return state.initialised[parentId]
                    ? state.data[parentId]
                    : [];
            };
        };
    }

    /**
     * Get all items of resource.
     *
     * @param {object} state
     * @returns {array}
     */
    return function (state) {
        return state.initialised
            ? state.data
            : [];
    };
}

/**
 * Generate byId getter.
 *
 * @param {object} settings
 * @returns {function}
 */
export function byId(settings) {
    /**
     * Get item of resource by ID.
     *
     * @param {object} state
     * @returns {function}
     */
    return function (state) {
        /**
         * Return item from data by ID
         *
         * @param {int} id
         * @returns {object}
         */
        return function (id) {
            const data = settings.parent
                ? Object.keys(state.data).reduce((arr, parentId) => arr.concat(state.data[parentId]), [])
                : state.data;

            return state.initialised
                ? data.find(i => i && i.id === id)
                : null;
        };
    };
}

/**
 * Generate find getter.
 *
 * @param {object} settings
 * @returns {function}
 */
export function find(settings) {
    /**
     * Get item(s) of resource by field and value.
     *
     * @param {object} state
     * @returns {function}
     */
    return function (state) {
        if (settings.parent) {
            /**
             * Return item(s) by parent ID, field and value
             *
             * @param {int} parentId
             * @param {string} field
             * @param {int|string} value
             * @param {boolean=} justOne
             * @returns {(object|array)}
             */
            return function (parentId, field, value, justOne = false) {
                return state.initialised[parentId]
                    ? state.data[parentId][justOne ? 'find' : 'filter'](i => i[field] === value)
                    : (justOne ? null : []);
            };
        }

        /**
         * Return item(s) by field and value
         *
         * @param {string} field
         * @param {int|string} value
         * @param {boolean=} justOne
         * @returns {(object|array)}
         */
        return function (field, value, justOne = false) {
            return state.initialised
                ? state.data[justOne ? 'find' : 'filter'](i => i[field] === value)
                : (justOne ? null : []);
        };
    };
}

/**
 * Generate template getter.
 *
 * @param {object} settings
 * @returns {function}
 */
export function template(settings) {
    /**
     * Get template for new item from settings.
     *
     * @returns {function}
     */
    return function () {
        /**
         * Create new template instance
         *
         * @returns {object}
         */
        return function () {
            return settings.template ? settings.template() : {};
        };
    };
}