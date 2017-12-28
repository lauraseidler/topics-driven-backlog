import { mount, createLocalVue } from 'vue-test-utils';
import moment from 'moment';
import Vuex from 'vuex';
import Vuelidate from 'vuelidate';
import SprintItem from '@/components/elements/SprintItem';
import SprintForm from '@/components/forms/SprintForm';
import '@/directives/confirm';

// take a date far in the future so validations pass
Date.now = jest.fn(() => 7956915742000);

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.use(Vuelidate);

describe('SprintItem.test.js', () => {
    let cmp, actions, store;

    beforeEach(() => {
        actions = {
            patch: jest.fn(),
            delete: jest.fn(),
        };

        store = new Vuex.Store({
            modules: {
                sprints: {
                    namespaced: true,
                    actions,
                },
            },
        });

        cmp = mount(SprintItem, {
            localVue,
            store,
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
                },
            },
        });
    });

    it('shows edit and delete buttons when end_date not in the past', () => {
        expect(cmp.findAll('.card-body .btn').length).toBe(2);
        expect(cmp.element).toMatchSnapshot();
    });

    it('calls starts editing when edit button is clicked', () => {
        cmp.vm.startEditing = jest.fn();
        cmp.update();

        cmp
            .findAll('.card-body .btn')
            .at(1)
            .trigger('click');

        expect(cmp.vm.startEditing).toBeCalled();
    });

    it('is in edit mode after startEditing was called', () => {
        cmp.vm.startEditing();
        cmp.update();
        expect(cmp.vm.editing).toBe(true);
        expect(cmp.vm.editingData).toBeTruthy();
        expect(cmp.element).toMatchSnapshot();
    });

    it('triggers sprint save when sprint form triggers submit', () => {
        cmp.vm.startEditing();
        cmp.vm.saveSprint = jest.fn();
        cmp.update();        

        cmp.find(SprintForm).trigger('submit');
        expect(cmp.vm.saveSprint).toBeCalled();
    });

    it('patches the sprint and leaves editing mode on sprint save', () => {
        cmp.vm.saveSprint();

        expect(actions.patch).toBeCalled();
        expect(cmp.vm.editing).toBe(false);
    });

    it('deletes the sprint when delete button is clicked', () => {
        const confirmSpy = jest
            .spyOn(window, 'confirm')
            .mockImplementation(() => true);

        cmp
            .findAll('.card-body .btn')
            .at(0)
            .trigger('click');

        expect(confirmSpy).toHaveBeenCalled();
        expect(actions.delete).toHaveBeenCalled();
    });
});
