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
     * @param {object=} payload
     * @param {int} payload.parentId
     * @param {int} payload.id
     */
    return async function ({ state, dispatch, rootState }, { id = null, parentId = null }) {
        // if resource has parent and parentId is set, dispatch partial fetch
        // else if no parent, dispatch full fetch
        // else configuration is incorrect

        if (settings.parent && parentId) {
            if (!state.initialised[parentId]) {
                await dispatch(`${settings.parent}/${actionTypes.FETCH}`, {}, { root: true });
            }
        } else if (!settings.parent) {
            if (!state.initialised) {
                await dispatch(actionTypes.FETCH, {});
            }
        } else {
            throw 'Incorrect resource module configuration!';
        }

        if (settings.children) {
            let childrenInitialised = true;

            settings.children.forEach(child => {
                if (!rootState[child].initialised[id]) {
                    childrenInitialised = false;
                }
            });

            if (!childrenInitialised) {
                await dispatch(actionTypes.FETCH, { id, parentId });
            }
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
     * @param {object=} payload
     * @param {int} payload.id
     * @param {int} payload.parentId
     * @returns {array|object}
     */
    return async function ({ commit }, { id = null, parentId = null }) {
        let url = `/${settings.resource}`;
        url += id ? `/${id}` : '';

        const res = await Vue.http.get(url);

        // if resource has children, patch the data through to the child store
        // then delete the data from the resource that's being stored to avoid duplication
        if (settings.children) {
            if (id) {
                settings.children.forEach(child => {
                    commit(`${child}/${mutationTypes.SET_ALL}`, {
                        parentId: res.body.id,
                        items: res.body[child],
                    }, { root: true });

                    delete res.body[child];
                });
            } else {
                res.body.forEach((item, index) => {
                    settings.children.forEach(child => {
                        commit(`${child}/${mutationTypes.SET_ALL}`, {
                            parentId: res.body[index].id,
                            items: res.body[index][child],
                        }, { root: true });

                        delete res.body[index][child];
                    });
                });
            }
        }

        // if an ID is set, update the one item we just fetched
        // else set all items
        if (id) {
            commit(mutationTypes.SET_ONE, {
                parentId,
                item: res.body,
            });
        } else {
            commit(mutationTypes.SET_ALL, {
                items: res.body,
            });
        }


        return res.body;
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
     * @param {int=} item.parentId
     * @param {object} item.values
     * @returns {object}
     */
    return async function ({ commit }, { parentId, ...values }) {
        let url = settings.parent ? `/${settings.parent}/${parentId}` : '';
        url += `/${settings.resource}`;

        const res = await Vue.http.post(url, values);
        commit(mutationTypes.SET_ONE, { parentId, item: res.body });
        return res.body;
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
     * @param {int=} item.parentId
     * @param {object} item.values
     * @returns {object}
     */
    return async function ({ commit }, { id, parentId, ...values }) {
        const res = await Vue.http.patch(`/${settings.resource}/${id}`, values);
        commit(mutationTypes.SET_ONE, { parentId, item: res.body });
        return res.body;
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
     */
    return async function ({ commit }, { id, parentId }) {
        await Vue.http.delete(`/${settings.resource}/${id}`);
        commit(mutationTypes.REMOVE_ONE, { id, parentId });
    };
}

