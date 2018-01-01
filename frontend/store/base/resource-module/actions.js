import Vue from 'vue';
import mutationTypes from './mutation-types';
import actionTypes from './action-types';

/**
 * Generate init action.
 *
 * @param {object} settings
 * @returns {function}
 */
export function init(settings) {
    /**
     * Initialise the store.
     *
     * @param {object} operations
     * @param {object} operations.state
     * @param {function} operations.dispatch
     * @param {int=} parentId
     */
    return async function ({ state, dispatch }, parentId = null) {
        // if resource has parent and parentId is set, dispatch partial fetch
        // else if no parent, dispatch full fetch
        // else configuration is incorrect
        if (settings.parent && parentId) {
            if (!state.initialised[parentId]) {
                await dispatch(`${settings.parent}/${actionTypes.FETCH}`, null, { root: true });
            }
        } else if (!settings.parent) {
            if (!state.initialised) {
                await dispatch(actionTypes.FETCH);
            }
        } else {
            throw new Error('Incorrect resource module configuration!');
        }
    };
}

/**
 * Generate fetch action.
 *
 * @param {object} settings
 * @returns {function}
 */
export function fetch(settings) {
    /**
     * Fetch all items.
     *
     * @param {object} operations
     * @param {function} operations.commit
     * @returns {array|object}
     */
    return async function ({ commit }) {
        try {
            const res = await Vue.http.get(`/${settings.resource}`);

            // if resource has children, patch the data through to the child store
            // then delete the data from the resource that's being stored to avoid duplication
            if (settings.children) {
                res.body.forEach((item, index) => {
                    settings.children.forEach(child => {
                        commit(`${child}/${mutationTypes.SET_ALL}`, {
                            id: res.body[index].id,
                            items: res.body[index][child],
                        }, { root: true });

                        delete res.body[index][child];
                    });
                });
            }

            commit(mutationTypes.SET_ALL, {
                items: res.body,
            });

            return res.body;
        } catch (err) {
            return err;
        }
    };
}

/**
 * Generate create action.
 *
 * @param {object} settings
 * @returns {function}
 */
export function create(settings) {
    /**
     * Create an item.
     *
     * @param {object} operations
     * @param {function} operations.commit
     * @param {object} item
     * @returns {object}
     */
    return async function ({ commit }, item) {
        try {
            const res = await Vue.http.post(`/${settings.resource}`, item);
            commit(mutationTypes.SET_ONE, res.body);
            return res.body;
        } catch (err) {
            return err;
        }
    };
}

/**
 * Generate update action.
 *
 * @param {object} settings
 * @returns {function}
 */
export function update(settings) {
    /**
     * Update an item.
     *
     * @param {object} operations
     * @param {function} operations.commit
     * @param {object} item
     * @param {int} item.id
     * @param {object} item.values
     * @returns {object}
     */
    return async function ({ commit }, { id, ...values }) {
        try {
            const res = await Vue.http.patch(`/${settings.resource}/${id}`, values);
            commit(mutationTypes.SET_ONE, res.body);
            return res.body;
        } catch (err) {
            return err;
        }
    };
}

/**
 * Generate remove action.
 *
 * @param {object} settings
 * @returns {function}
 */
export function remove(settings) {
    /**
     * Remove an item.
     *
     * @param {object} operations
     * @param {function} operations.commit
     * @param {object} item
     * @param {int} item.id
     * @returns {undefined|object}
     */
    return async function ({ commit }, { id }) {
        try {
            await Vue.http.delete(`/${settings.resource}/${id}`);
            commit(mutationTypes.REMOVE_ONE, { id });
        } catch (err) {
            return err;
        }
    };
}

