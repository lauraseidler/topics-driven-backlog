import { mount, createLocalVue } from 'vue-test-utils';
import mockRouter from 'mock-vue-router';
import Vuex from 'vuex';
import Vuelidate from 'vuelidate';
import CoursePage from '@/components/pages/CoursePage';

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.use(Vuelidate);

const { $router, $route } = mockRouter(['/courses/:id'], '/courses/1');

describe('CoursePage.test.js', () => {
    let cmp, store, actions, getters;

    beforeEach(() => {
        actions = {
            save: jest.fn(),
            saveCollection: jest.fn(),
        };

        getters = {
            byId: () => id =>
                [
                    {
                        id: 1,
                        title: 'Test course',
                        semester_type: 'W',
                        semester_year: 2017,
                        sprints: [
                            { id: 1, start_date: '2000-01-02' },
                            { id: 2, start_date: '2000-01-01' },
                        ],
                    },
                    {
                        id: 2,
                        title: 'Test course',
                        semester_type: 'W',
                        semester_year: 2017,
                    },
                    { id: 3 },
                    { id: 4 },
                ][id - 1],
        };

        store = new Vuex.Store({
            modules: {
                courses: {
                    namespaced: true,
                    getters,
                },
                sprints: {
                    namespaced: true,
                    actions,
                },
            },
        });

        cmp = mount(CoursePage, {
            localVue,
            store,
            mocks: {
                $router,
                $route,
            },
        });
    });

    it('returns correct course from route param', () => {
        expect(cmp.vm.course.title).toBe('Test course');
    });

    it('returns correctly sorted sprints for course', () => {
        expect(cmp.vm.sprints).toEqual([
            { id: 2, start_date: '2000-01-01' },
            { id: 1, start_date: '2000-01-02' },
        ]);

        cmp.vm.$router.push('/courses/2');

        expect(cmp.vm.sprints.length).toBe(0);
    });

    it('adds a sprint and resets form', () => {
        cmp.vm.addSprint();

        expect(actions.save).toBeCalled();
        expect(cmp.vm.newSprint).toEqual({});
    });

    it('adds a sprint collection and resets form', () => {
        cmp.vm.addCollection();

        expect(actions.saveCollection).toBeCalled();
        expect(cmp.vm.newCollection).toEqual({});
    });

    it('has the expected html structure', () => {
        expect(cmp.element).toMatchSnapshot();
    });
});
