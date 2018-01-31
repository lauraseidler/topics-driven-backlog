import { mount } from 'vue-test-utils';
import ProjectItem from '@/components/elements/ProjectItem';
import '@/directives/confirm';


describe('The ProjectItem component', () => {
    let cmp, dispatch = jest.fn(), form;

    const mocks = {
        $store: {
            state: {
                user: { id: 1 },
            },  
            dispatch,
            getters: {
                'courses/byId': () => {
                    return {
                        id: 1,
                        allow_enrollment: true,
                    };
                },
                'projects/all': () => {
                    return [];
                },  
            },
        },
        $style: {},
    };


    beforeAll(() => {
        cmp = mount(ProjectItem, {
            propsData: {
                data: {
                    id: 1,
                    title: 'Test Project',
                    user_ids: [],
                },
            },
            mocks,
        });
    });

    beforeEach(() => {
        jest.resetAllMocks();
    });

    it('is a list item that contains a card body', () => {
        expect(cmp.is('li.card')).toBe(true);
        expect(cmp.findAll('.card-body').length).toBe(1);
    });

    it('has a the project title as title', () => {
        const title = cmp.find('.card-title');
        expect(title.text()).toBe('Test Project');
    });

    it('shows join project button and dispatches enroll action when clicked', () => {
        const joinButton = cmp.find('.card-text button.btn-primary');
        expect(joinButton.text()).toBe('Join project');

        joinButton.trigger('click');
        expect(dispatch).toHaveBeenCalled();
    });

    describe('in "new" mode', () => {
        let cmp;

        beforeAll(() => {
            cmp = mount(ProjectItem, {
                propsData: {
                    data: {
                        id: 1,
                        title: 'Test Project',
                        user_ids: [],
                    },
                    view: 'new',
                    courseId: 1,
                },
                mocks,
            });
        });

        it('shows a plus icon and text', () => {
            expect(cmp.find('.fa-icon')).toBeTruthy();
            expect(cmp.find('strong').text()).toBe('Create new project in course');
        });

        it('shows project form when plus is clicked', () => {
            cmp.find('div div').trigger('click');
            form = cmp.find('.project-form');
            expect(form).toBeTruthy();
        });

        it('dispatches project create action', () => {
            form.trigger('submit');

            expect(dispatch).toHaveBeenCalledWith('projects/create', {
                parentId: 1,
                title: 'Test Project',
            });
        });
    });

    describe('when the user is enrolled', () => {
        beforeAll(() => {
            cmp = mount(ProjectItem, {
                propsData: {
                    data: {
                        id: 1,
                        course_id: 1,
                        title: 'Test Project',
                        user_ids: [1],
                    },
                },
                mocks,
            });
        });

        beforeEach(() => {
            jest.resetAllMocks();
        });

        it('shows a link to the backlog', () => {
            const link = cmp.find('.card-text router-link');
            expect(link.text()).toBe('View Backlog');
            expect(link.vnode.data.attrs.to).toBe('/projects/1-test-project');
        });

        it('shows leave project button and dispatches disenroll action when clicked', () => {
            const confirmSpy = jest
                .spyOn(window, 'confirm')
                .mockImplementation(() => true);

            const leaveButton = cmp.find('.card-text button.btn-primary');
            expect(leaveButton.text()).toBe('Leave project');

            leaveButton.trigger('click');
            expect(confirmSpy).toHaveBeenCalled();
            expect(dispatch).toHaveBeenCalled();
        });

        it('shows project form when edit button is clicked', () => {
            const editButton = cmp.find('.btn-outline-primary');
            expect(editButton.find('.fa-icon')).toBeTruthy();
            editButton.trigger('click');

            form = cmp.find('.project-form');
            expect(form).toBeTruthy();
        });
    
        it('dispatches save action when form is submitted', () => {
            form.trigger('submit');

            expect(dispatch).toHaveBeenCalledWith('projects/update', {
                id: 1,
                parentId: 1,
                title: 'Test Project',
            });
        });

        it('dispatches delete action when delete button is clicked', () => {
            const confirmSpy = jest
                .spyOn(window, 'confirm')
                .mockImplementation(() => true);
    
            cmp.update();
    
            const deleteButton = cmp.find('.btn-outline-danger');
            expect(deleteButton.find('.fa-icon')).toBeTruthy();
            deleteButton.trigger('click');
            
            expect(confirmSpy).toHaveBeenCalled();
            expect(dispatch).toHaveBeenCalledWith('projects/remove', {
                id: 1,
                parentId: 1,
            });
        });

        describe('and enrollment is closed', () => {
            beforeAll(() => {
                cmp = mount(ProjectItem, {
                    propsData: {
                        data: {
                            id: 1,
                            course_id: 1,
                            title: 'Test Project',
                            user_ids: [1],
                        },
                    },
                    mocks,
                });

                cmp.vm.$store.getters['courses/byId'] = () => {
                    return {
                        id: 1,
                        allow_enrollment: false,
                    };
                };

                cmp.update();
            });
    
            beforeEach(() => {
                jest.resetAllMocks();
            });

            it('does not show leave project button', () => {
                expect(cmp.findAll('.card-text button.btn-primary').length).toBe(0);
            });

            it('does not edit and delete buttons', () => {
                expect(cmp.findAll('.btn-outline-primary').length).toBe(0);
                expect(cmp.findAll('.btn-outline-danger').length).toBe(0);
            });
        });

        describe('into a different project', () => {
            beforeAll(() => {
                cmp = mount(ProjectItem, {
                    propsData: {
                        data: {
                            id: 1,
                            course_id: 1,
                            title: 'Test Project',
                            user_ids: [],
                        },
                    },
                    mocks,
                });

                cmp.vm.$store.getters['projects/all'] = () => {
                    return [{
                        user_ids: [1],
                    }];
                };

                cmp.update();
            });
    
            beforeEach(() => {
                jest.resetAllMocks();
            });

            it('does not show join project button', () => {
                expect(cmp.findAll('.card-text button.btn-primary').length).toBe(0);
            });
        });
    });
});
