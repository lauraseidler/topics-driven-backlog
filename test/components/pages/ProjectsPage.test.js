import { mount } from 'vue-test-utils';
import ProjectsPage from '@/components/pages/ProjectsPage';

describe('ProjectsPage.test.js', () => {
    let cmp;

    beforeEach(() => {
        cmp = mount(ProjectsPage, {
            mocks: {
                $store: {
                    state: {
                        user: { id: 1 },
                    },
                    getters: {
                        'projects/all': () => [{
                            title: 'Test project',
                            user_ids: [1],
                        }, {
                            title: 'Test project 2',
                            user_ids: [2],
                        }],
                        'projects/template': () => {
                            return {
                                title: '',
                            };
                        },
                    },
                },
                $style: {},
            },
        });
    });

    it('calculates user enrollment correctly', () => {
        expect(cmp.vm.isEnrolledToProjectInCourse(1)).toBe(true);
    });
});
