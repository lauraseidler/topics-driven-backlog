import { mount } from 'vue-test-utils';
import moment from 'moment';
import SprintItem from '@/components/elements/SprintItem';
import '@/directives/confirm';

// take a date far in the future so validations pass
Date.now = jest.fn(() => 7956915742000);

describe('The SprintItem component', () => {
    let cmp, dispatch = jest.fn(), form;

    beforeAll(() => {
        cmp = mount(SprintItem, {
            propsData: {
                data: {
                    id: 1,
                    name: 'Test Sprint',
                    start_date: moment()
                        .add(5, 'days')
                        .format('YYYY-MM-DD'),
                    end_date: moment()
                        .add(7, 'days')
                        .format('YYYY-MM-DD'),
                    topic_ids: [1, 2],
                    permissions: {
                        sprint: {
                            update: true,
                            delete: true,
                        },
                    },
                },
            },
            mocks: {
                $store: {
                    dispatch,
                    getters: {
                        'courses/byId': () => {
                            return {
                                id: 1,
                                permissions: {
                                    sprint: {
                                        update: true,
                                        delete: true,
                                    },
                                },
                            };
                        },
                        'topics/byId': () => {
                            return {
                                title: 'Topic title',
                                permissions: {
                                    sprint: {
                                        update: true,
                                        delete: true,
                                    },
                                },
                            };
                        },
                        'topics/all': () => [],
                        'sprints/all': () => [],
                    },
                    state: {},
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

    it('shows the topics as a string in the text', () => {
        expect(cmp.find('.card-text').text()).toEqual(expect.stringContaining('Topic title | Topic title'));
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

    it('shows sprint form when edit button is clicked', () => {
        const editButton = cmp.find('.btn-outline-primary');
        expect(editButton.find('.fa-icon')).toBeTruthy();
        editButton.trigger('click');
        form = cmp.find('.sprint-form');
        expect(form).toBeTruthy();
    });

    it('dispatches save action when form is submitted', () => {
        form.trigger('submit');
        expect(dispatch).toHaveBeenCalled();
    });
});
