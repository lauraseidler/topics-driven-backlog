import * as mutations from './mutations';
import * as actions from './actions';
import * as getters from './getters';

import mutationTypes from './mutation-types';
import actionTypes from './action-types';
import getterTypes from './getter-types';

/**
 * Generate a Vuex module for a resource
 *
 * @param {object} settings
 * @param {string} settings.resource
 * @param {string=} settings.parent
 * @param {string[]=} settings.children
 * @returns {object}
 */
export function generate({ resource, parent = null, children = null }) {
    const settings = { resource, parent, children };

    const base = {
        namespaced: true,
        state: {
            initialised: parent ? {} : false,
            data: parent ? {} : [],
        },
        mutations: {},
        actions: {},
        getters: {},
    };

    // load all mutations
    for (let mutationType in mutationTypes) {
        base.mutations[mutationTypes[mutationType]] = mutations[mutationTypes[mutationType]](settings);
    }

    // load all actions
    for (let actionType in actionTypes) {
        base.actions[actionTypes[actionType]] = actions[actionTypes[actionType]](settings);
    }

    // load all getters
    for (let getterType in getterTypes) {
        base.getters[getterTypes[getterType]] = getters[getterTypes[getterType]](settings);
    }

    console.log(base);

    return base;
}