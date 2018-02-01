import { mount } from 'vue-test-utils';
import mockRouter from 'mock-vue-router';
import CoursePage from '@/components/pages/CoursePage';

const { $router, $route } = mockRouter(['/courses/:id'], '/courses/1');

describe('CoursePage.test.js', () => {
    let cmp, dispatch = jest.fn();

    beforeEach(() => {
        cmp = mount(CoursePage, {
            mocks: {
                $router,
                $route,
                $store: {
                    dispatch,
                    state: {
                        loggedIn: true,
                        user: {
                            id: 1,
                        },
                    },
                    getters: {
                        'sprints/template': () => { return {}; },
                        'projects/template': () => { return {}; },
                        'topics/template': () => { return {}; },
                        'courses/byId': () => { 
                            return { 
                                id: 1,
                                title: 'Test course',
                                hyperlink: 'http://google.com',
                                short_title: 'TEST',
                                semester_type: 'WS',
                                semester_year: 2222,
                                permissions: {
                                    projects: {
                                        read: true,
                                        create: true,
                                    },
                                    topics: {
                                        read: true,
                                        create: true,
                                    },
                                    sprints: {
                                        read: true,
                                        create: true,
                                    },
                                },
                            }; 
                        },
                        'sprints/all': () => [
                            { id: 1, start_date: '2000-01-02', topic_ids: [] },
                            { id: 2, start_date: '2000-01-01', topic_ids: [] },
                        ],
                        'projects/all': () => [
                            { id: 1, title: 'Test', user_ids: [] },
                            { id: 2, title: 'Test 2', user_ids: [] },
                        ],
                        'topics/all': () => [],
                    },
                },
                $style: {},
            },
        });

        cmp.vm.$router.push('/courses/1');

        jest.resetAllMocks();
    });

    it('returns correct course from route param', () => {
        expect(cmp.vm.course.title).toBe('Test course');
    });

    it('returns correctly sorted sprints and projects for course', () => {
        expect(cmp.vm.sprints).toEqual([
            { id: 2, start_date: '2000-01-01', topic_ids: [] },
            { id: 1, start_date: '2000-01-02', topic_ids: [] },
        ]);

        expect(cmp.vm.projects).toEqual([
            { id: 1, title: 'Test', user_ids: [] },
            { id: 2, title: 'Test 2', user_ids: [] },
        ]);
    });

    it('adds a sprint and resets form', () => {
        cmp.vm.addSprint();

        expect(dispatch).toBeCalled();
        expect(cmp.vm.newSprint).toEqual({});
    });

    it('adds a sprint collection and resets form', () => {
        cmp.vm.addCollection();

        expect(dispatch).toBeCalled();
        expect(cmp.vm.newCollection).toEqual({});
    });


    it('adds a project and resets form', () => {
        cmp.vm.addProject();

        expect(dispatch).toBeCalled();
        expect(cmp.vm.newSprint).toEqual({});
    });

    it('adds a topic and resets form', () => {
        cmp.vm.addTopic();

        expect(dispatch).toBeCalled();
        expect(cmp.vm.newTopic).toEqual({});
    });

    it('does not calculate sprints, projects or topics if no course set', () => {
        cmp.vm.$store.getters['courses/byId'] = () => null;
        cmp.update();

        expect(cmp.vm.sprints.length).toBe(0);
        expect(cmp.vm.projects.length).toBe(0);
        expect(cmp.vm.topics.length).toBe(0);
    });
});
