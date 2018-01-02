import Vue from 'vue';

/**
 * Generate mutation for setting one item.
 *
 * @param {object} settings
 * @returns {function}
 */
export function setOne(settings) {
    /**
     * Add or update the given item to/in the data.
     * If the item already exists (check by id), it will be updated.
     * If the item does not exist yet, it will be added.
     *
     * @param {object} state
     * @param {object} payload
     * @param {int=} payload.parentId
     * @param {object} payload.item
     */
    return function (state, { parentId, item }) {
        if (settings.parent && parentId) {
            const alreadyExists = state.data[parentId].find(i => i.id === item.id);

            if (alreadyExists) {
                Vue.set(
                    state.data,
                    parentId,
                    state.data[parentId].map(i => (i.id === item.id ? item : i))
                );
            } else {
                state.data[parentId].push(item);
            }
        } else if (!settings.parent) {
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
        } else {
            throw new Error('Incorrect resource module configuration!');
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
     * @param {int=} payload.parentId
     * @param {array} payload.items
     */
    return function (state, { parentId, items }) {
        // if resource has parent and id is set, set part of data
        // else if no parent, set entire data
        // else configuration is incorrect
        if (settings.parent && parentId) {
            Vue.set(state.data, parentId, items);
            state.initialised[parentId] = true;
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
 * @param {object} settings
 * @returns {function}
 */
export function removeOne(settings) {
    /**
     * Remove an item from the data.
     * If the item exists (check by id), it will be removed.
     * If the item does not exist, the data will remain as is.
     *
     * @param {object} state
     * @param {object} item
     * @param {int} item.id
     * @param {parentId=} item.parentId
     */
    return function (state, { id, parentId }) {
        if (settings.parent && parentId) {
            Vue.set(state.data, parentId, state.data[parentId].filter(i => i.id !== id));
        } else if (!settings.parent) {
            Vue.set(state, 'data', state.data.filter(i => i.id !== id));
        } else {
            throw new Error('Incorrect resource module configuration!');
        }
    };
}