
import { mount } from 'vue-test-utils';
import CourseItem from '@/components/elements/CourseItem';
import '@/directives/confirm';

describe('The CourseItem component', () => {
    let cmp, dispatch = jest.fn(), form;

    beforeAll(() => {
        cmp = mount(CourseItem, {
            propsData: {
                data: {
                    id: 1,
                    title: 'Test course',
                    hyperlink: 'http://google.com',
                    short_title: 'TEST',
                    semester_type: 'WS',
                    semester_year: 2222,
                    permissions: {
                        course: {
                            update: true,
                            delete: true,
                        },
                    },
                },
            },
            mocks: {
                $store: {
                    dispatch,
                },
            },
        });
    });

    beforeEach(() => {
        jest.resetAllMocks();
    });

    it('is a list item that contains a card body', () => {
        expect(cmp.is('li.card')).toBe(true);
        expect(cmp.findAll('.card-body').length).toBe(1);
    });

    it('has a link to the course page as title', () => {
        const title = cmp.find('.card-title');
        expect(title.text()).toBe('TEST');
        expect(title.vnode.data.attrs.to).toBe('/courses/1-test-course');
    });

    it('has a button link to the course page after the text', () => {
        const btn = cmp.find('.card-text + router-link');
        expect(btn.text()).toBe('View details');
        expect(btn.vnode.data.attrs.to).toBe('/courses/1-test-course');
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
        expect(dispatch).toHaveBeenCalled();
    });

    it('shows course form when edit button is clicked', () => {
        const editButton = cmp.find('.btn-outline-primary');
        expect(editButton.find('.fa-icon')).toBeTruthy();
        editButton.trigger('click');
        form = cmp.find('.course-form');
        expect(form).toBeTruthy();
    });

    it('dispatches save action when form is submitted', () => {
        form.trigger('submit');
        expect(dispatch).toHaveBeenCalled();
    });
});
