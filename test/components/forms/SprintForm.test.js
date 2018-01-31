import { mount } from 'vue-test-utils';
import moment from 'moment';
import SprintForm from '@/components/forms/SprintForm';

// take a date far in the future so validations pass
Date.now = jest.fn(() => 7956915742000);

describe('SprintForm.test.js', () => {
    let cmp, dispatch = jest.fn();

    beforeAll(() => {
        cmp = mount(SprintForm, {
            propsData: {
                data: {
                    id: 1,
                    name: 'Test Sprint',
                    start_date: moment().format('YYYY-MM-DD'),
                    end_date: moment()
                        .add(5, 'days')
                        .format('YYYY-MM-DD'),
                },
                course: {
                    id: 1,
                },
            },
            mocks: {
                $store: {
                    dispatch,
                    state: {
                        currentDate: moment().format('YYYY-MM-DD'),
                    },
                    getters: {
                        'topics/all': () => [],
                        'sprints/all': () => [{
                            id: 1,
                            name: 'Test Sprint',
                            start_date: moment().format('YYYY-MM-DD'),
                            end_date: moment()
                                .add(5, 'days')
                                .format('YYYY-MM-DD'),
                        }, {
                            id: 2,
                            name: 'Test Sprint 2',
                            start_date: moment()
                                .add(6, 'days')
                                .format('YYYY-MM-DD'),
                            end_date: moment()
                                .add(7, 'days')
                                .format('YYYY-MM-DD'),
                        }, {
                            id: 3,
                            name: 'Test Sprint 3',
                            start_date: moment()
                                .add(8, 'days')
                                .format('YYYY-MM-DD'),
                            end_date: moment()
                                .add(9, 'days')
                                .format('YYYY-MM-DD'),
                        }],
                    },
                },
            },
        });
    });

    it('is a form with class sprint-form', () => {
        expect(cmp.is('form.sprint-form')).toBe(true);
    });

    it('returns the same sprints as new sprints when not overlapping', () => {
        expect(cmp.vm.sprints).toEqual(cmp.vm.newSprints);
    });

    it('recognises overlapping state after changing a value', () => {
        cmp.vm.data.start_date = moment()
            .add(7, 'days')
            .format('YYYY-MM-DD');
            
        cmp.vm.data.end_date = moment()
            .add(8, 'days')
            .format('YYYY-MM-DD');

        cmp.update();

        expect(cmp.vm.isOverlapping).toBe(true);
    });

    it('dispatches update collection action', () => {
        const button = cmp.findAll('.btn-primary').at(1);
        expect(button.text()).toBe('Save and adjust other sprint dates');
        
        button.trigger('click');
        expect(dispatch).toHaveBeenCalled();
    });

    it('doesnt calculate topics or sprints if no course is set', () => {
        const props = cmp.props;
        props.course = null;
        cmp.setProps(props);

        expect(cmp.vm.topics.length).toBe(0);
        expect(cmp.vm.sprints.length).toBe(0);
    });
});
