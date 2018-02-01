import { mount } from 'vue-test-utils';
import CoursesPage from '@/components/pages/CoursesPage';
import { current } from '@/helper/semester';

describe('CoursesPage.test.js', () => {
    let cmp, dispatch = jest.fn();

    beforeEach(() => {
        cmp = mount(CoursesPage, {
            mocks: {
                $store: {
                    dispatch,
                    state: {
                        user: {
                            permissions: {
                                courses: {
                                    create: true,
                                    read: true,
                                },
                            },
                        },
                    },
                    getters: {
                        'courses/all': () => [
                            {
                                title: 'Test course',
                                semester_type: 'W',
                                semester_year: 2017,
                                permissions: {

                                }
                            },
                        ],
                        'courses/template': () => {
                            return {
                                semester: current().valueString,
                                allow_enrollment: true,
                            };
                        },
                    },
                },
            },
        });

        jest.resetAllMocks();
    });

    it('adds a course', () => {
        cmp.vm.newCourse = {
            title: 'Test course',
            semester: 'W*2017',
        };

        cmp.vm.saveCourse();

        expect(dispatch).toBeCalled();
    });
});
