import { mount } from 'vue-test-utils';
import TopicItem from '@/components/elements/TopicItem';
import '@/directives/confirm';

describe('The TopicItem component', () => {
    let cmp, dispatch = jest.fn(), form;

    beforeAll(() => {
        cmp = mount(TopicItem, {
            propsData: {
                data: {
                    id: 1,
                    title: 'Test topic',
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
        expect(title.text()).toBe('Test topic');
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

    it('shows topic form when edit button is clicked', () => {
        const editButton = cmp.find('.btn-outline-primary');
        expect(editButton.find('.fa-icon')).toBeTruthy();
        editButton.trigger('click');
        form = cmp.find('.topic-form');
        expect(form).toBeTruthy();
    });

    it('dispatches save action when form is submitted', () => {
        form.trigger('submit');
        expect(dispatch).toHaveBeenCalled();
    });
});
