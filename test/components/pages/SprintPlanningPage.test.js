import { mount, createLocalVue } from 'vue-test-utils';
import moment from 'moment';
import Vuex from 'vuex';
import Vuelidate from 'vuelidate';
import SprintPlanningPage from '@/components/pages/SprintPlanningPage';

// take a date far in the future so validations pass
Date.now = jest.fn(() => 7956915742000);

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.use(Vuelidate);

describe('SprintPlanningPage.test.js', () => {
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
                { id: 3, position: 3, status: 0, sprint_id: 2 },
                { id: 4, position: 4, status: 1 },
            ],
            find: () => () => [
                { id: 5, position: 5, status: 0, sprint_id: 1 },
                { id: 3, position: 3, status: 0, sprint_id: 1 },
            ],
        };
    });

    describe('with sprints', () => {
        beforeEach(() => {
            courseGetters = {
                allSprints: () => () => [
                    {
                        id: 1,
                        start_date: moment().format('YYYY-MM-DD'),
                        end_date: moment()
                            .add(2, 'days')
                            .format('YYYY-MM-DD'),
                    },
                    {
                        id: 2,
                        start_date: moment()
                            .subtract(1, 'days')
                            .format('YYYY-MM-DD'),
                        end_date: moment()
                            .subtract(1, 'days')
                            .add(2, 'days')
                            .format('YYYY-MM-DD'),
                    },
                ],
            };

            store = new Vuex.Store({
                modules: {
                    stories: {
                        namespaced: true,
                        actions,
                        getters: storyGetters,
                    },
                    courses: {
                        namespaced: true,
                        getters: courseGetters,
                    },
                },
            });

            cmp = mount(SprintPlanningPage, {
                localVue,
                store,
            });
        });

        it('has sorted backlog with stories not in sprints of all statuses', () => {
            expect(cmp.vm.backlog).toEqual([
                { id: 2, position: 1, status: 0 },
                { id: 1, position: 2, status: 0 },
                { id: 4, position: 4, status: 1 },
            ]);
        });

        it('has correct next sprint', () => {
            expect(cmp.vm.nextSprint).toEqual(courseGetters.allSprints()()[1]);
        });

        it('has stories that are in next sprint ordered by position', () => {
            expect(cmp.vm.storiesInSprint).toEqual([
                { id: 3, position: 3, status: 0, sprint_id: 1 },
                { id: 5, position: 5, status: 0, sprint_id: 1 },
            ]);
        });

        it('dispatches save on story save', () => {
            cmp.vm.save();
            expect(actions.save).toBeCalled();
        });

        it('doesnt save the story order if story not found', () => {
            cmp.vm.saveOrder({ oldIndex: 2 });
            expect(actions.patch).not.toBeCalled();
        });

        it('saves the story order on sortable event', () => {
            cmp.vm.saveOrder({ oldIndex: 0, newIndex: 1 });
            expect(actions.patch).toBeCalled();
        });

        it('adds a story to a sprint', () => {
            cmp.vm.addToSprint(1);
            expect(actions.patch).toBeCalled();
        });

        it('adds a story from a sprint', () => {
            cmp.vm.removeFromSprint(1);
            expect(actions.patch).toBeCalled();
        });

        it('has the expected html structure', () => {
            expect(cmp.element).toMatchSnapshot();
        });
    });

    describe('without sprints', () => {
        beforeEach(() => {
            courseGetters = {
                allSprints: () => () => [],
            };

            store = new Vuex.Store({
                modules: {
                    stories: {
                        namespaced: true,
                        actions,
                        getters: storyGetters,
                    },
                    courses: {
                        namespaced: true,
                        getters: courseGetters,
                    },
                },
            });

            cmp = mount(SprintPlanningPage, {
                localVue,
                store,
            });
        });

        it('has no next sprint if no sprints', () => {
            expect(cmp.vm.nextSprint).toBeFalsy();
        });

        it('has no stories in sprint if no sprint', () => {
            expect(cmp.vm.storiesInSprint).toEqual([]);
        });

        it('doesnt a story to a sprint if no sprint', () => {
            cmp.vm.addToSprint(1);
            expect(actions.patch).not.toBeCalled();
        });

        it('has the expected html structure', () => {
            expect(cmp.element).toMatchSnapshot();
        });
    });
});
