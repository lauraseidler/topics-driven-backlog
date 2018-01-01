import Vue from 'vue';

/**
 * Generate mutation for setting one item.
 *
 * @returns {function}
 */
export function setOne() {
    /**
     * Add or update the given item to/in the data.
     * If the item already exists (check by id), it will be updated.
     * If the item does not exist yet, it will be added.
     *
     * @param {object} state
     * @param {object} item
     */
    return function (state, item) {
        const alreadyExists = state.data.find(i => i.id === item.id);

        if (alreadyExists) {
            Vue.set(
                state,
                'data',
                state.data.map(i => (i.id === item.id ? item : i))
            );
        } else {
            state.data.push(item);
        }
    };
}

/**
 * Generate mutation for setting all items.
 *
 * @param {object} settings
 * @returns {function}
 */
export function setAll(settings) {
    /**
     * Set the entire array of items as the data of store or parent (by ID).
     * The existing array will be replaced.
     *
     * @param {object} state
     * @param {object} payload
     * @param {int} payload.id
     * @param {array} payload.items
     */
    return function (state, { id, items }) {
        // if resource has parent and id is set, set part of data
        // else if no parent, set entire data
        // else configuration is incorrect
        if (settings.parent && id) {
            Vue.set(state.data, id, items);
            state.initialised[id] = true;
        } else if (!settings.parent) {
            Vue.set(state, 'data', items);
            state.initialised = true;
        } else {
            throw new Error('Incorrect resource module configuration!');
        }
    };
}

/**
 * Generate mutation to remove an item.
 *
 * @returns {function}
 */
export function removeOne() {
    /**
     * Remove an item from the data.
     * If the item exists (check by id), it will be removed.
     * If the item does not exist, the data will remain as is.
     *
     * @param {object} state
     * @param {object} item
     */
    return function (state, item) {
        Vue.set(state, 'data', state.data.filter(i => i.id !== item.id));
    };
}