// turn off vue console info
console.info = jest.fn();

// mock dependencies
jest.mock('@/store/base/resource-module/mutations');
jest.mock('@/store/base/resource-module/actions');
jest.mock('@/store/base/resource-module/getters');

import { generate } from '@/store/base/resource-module/index';

import * as mutations from '@/store/base/resource-module/mutations';
import * as actions from '@/store/base/resource-module/actions';
import * as getters from '@/store/base/resource-module/getters';

import mutationTypes from '@/store/base/resource-module/mutation-types';
import actionTypes from '@/store/base/resource-module/action-types';
import getterTypes from '@/store/base/resource-module/getter-types';

describe('The resource module generator', () => {
    let module, settings, expectedDefaultSettings;

    beforeAll(() => {
        settings = {
            resource: 'test',
        };

        expectedDefaultSettings = {
            resource: 'test',
            parent: null,
            children: null,
            template: null,
            state: {},
        };

        module = generate(settings);
    });

    it('returns a complete and correctly configured vuex module', () => {
        expect(module.namespaced).toBe(true);
        expect(typeof module.state).toBe('object');
        expect(module.state.initialised).toBe(false);
        expect(module.state.data.length).toBe(0);
        expect(typeof module.mutations).toBe('object');
        expect(typeof module.actions).toBe('object');
        expect(typeof module.getters).toBe('object');
    });

    it('generates all defined mutations', () => {
        Object.keys(mutationTypes).forEach(mutation => {
            expect(mutations[mutationTypes[mutation]]).toHaveBeenCalledTimes(1);
            expect(mutations[mutationTypes[mutation]]).toHaveBeenCalledWith(expectedDefaultSettings);
        });
    });

    it('generates all defined actions', () => {
        Object.keys(actionTypes).forEach(action => {
            expect(actions[actionTypes[action]]).toHaveBeenCalledTimes(1);
            expect(actions[actionTypes[action]]).toHaveBeenCalledWith(expectedDefaultSettings);
        });
    });

    it('generates all defined getters', () => {
        Object.keys(getterTypes).forEach(getter => {
            expect(getters[getterTypes[getter]]).toHaveBeenCalledTimes(1);
            expect(getters[getterTypes[getter]]).toHaveBeenCalledWith(expectedDefaultSettings);
        });
    });

    describe('called with parent setting', () => {
        beforeAll(() => {
            module = generate({
                resource: 'tests',
                parent: 'tests2',
            });
        });

        it('returns a complete and correctly configured vuex module', () => {
            expect(typeof module.state.initialised).toBe('object');
            expect(typeof module.state.data).toBe('object');
        });
    });

    describe('given a state to extend the default state', () => {
        beforeAll(() => {
            module = generate({
                resource: 'tests',
                state: {
                    test: 'test',
                },
            });
        });

        it('returns a complete and correctly configured vuex module', () => {
            expect(typeof module.state).toBe('object');
            expect(module.state.initialised).toBe(false);
            expect(module.state.data.length).toBe(0);
            expect(module.state.test).toBe('test');
        });
    });
});