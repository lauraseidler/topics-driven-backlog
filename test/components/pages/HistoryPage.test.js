import { mount, createLocalVue } from 'vue-test-utils';
import { state } from '@/store/stories';
import Vuex from 'vuex';
import Vuelidate from 'vuelidate';
import HistoryPage from '@/components/pages/HistoryPage';

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.use(Vuelidate);

describe('HistoryPage.test.js', () => {
    let cmp, store, actions, storyGetters, courseGetters;

    beforeEach(() => {
        actions = {
            save: jest.fn(),
            patch: jest.fn(),
        };

        storyGetters = {
            all: () => [
                { id: 1, position: 2, status: 0 },
                { id: 2, position: 1, status: 0 },
                { id: 3, position: 3, status: 0, sprint_id: 1 },
                { id: 4, position: 4, status: 1 },
                { id: 5, position: 5, status: 0, sprint_id: 1 },
            ],
            find: () => () => [
                { id: 5, position: 5, status: 0, sprint_id: 1 },
                { id: 3, position: 3, status: 0, sprint_id: 1 },
            ],
        };

        courseGetters = {
            allSprints: () => () => [
                { id: 1, start_date: '2000-01-02' },
                { id: 2, start_date: '2000-01-01' },
            ],
        };

        store = new Vuex.Store({
            modules: {
                stories: {
                    namespaced: true,
                    state: {
                        STATUS: state.STATUS,
                        statusMap: state.statusMap,
                    },
                    actions,
                    getters: storyGetters,
                },
                courses: {
                    namespaced: true,
                    getters: courseGetters,
                },
            },
        });

        cmp = mount(HistoryPage, {
            localVue,
            store,
        });
    });

    it('has sorted stories in backlog', () => {
        expect(cmp.vm.backlog).toEqual([
            { id: 2, position: 1, status: 0 },
            { id: 1, position: 2, status: 0 },
            { id: 4, position: 4, status: 1 },
        ]);
    });

    it('has sorted sprints ', () => {
        expect(cmp.vm.sprints).toEqual([
            { id: 2, start_date: '2000-01-01' },
            { id: 1, start_date: '2000-01-02' },
        ]);
    });

    it('has the expected html structure', () => {
        expect(cmp.element).toMatchSnapshot();
    });
});
