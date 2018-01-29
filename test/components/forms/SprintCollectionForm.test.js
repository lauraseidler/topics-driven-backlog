import { mount, createLocalVue } from 'vue-test-utils';
import moment from 'moment';
import Vuex from 'vuex';
import Vuelidate from 'vuelidate';
import SprintCollectionForm from '@/components/forms/SprintCollectionForm';

// take a date far in the future so validations pass
Date.now = jest.fn(() => 7956915742000);

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.use(Vuelidate);

describe('SprintCollectionForm.test.js', () => {
    let cmp, store;

    beforeEach(() => {
        store = new Vuex.Store({
            currentDate: moment().format('YYYY-MM-DD'),
        });

        cmp = mount(SprintCollectionForm, {
            localVue,
            store,
            propsData: {
                data: {
                    duration: 2,
                    start_date: moment().format('YYYY-MM-DD'),
                    end_date: moment()
                        .add(5, 'days')
                        .format('YYYY-MM-DD'),
                },
            },
        });
    });

    it('calculates the correct number of days', () => {
        expect(cmp.vm.numberOfDays).toBe(6);
    });

    it('calculates the correct number of sprints', () => {
        expect(cmp.vm.numberOfSprints).toBe(3);
    });

    it('doesnt do calculations when form is invalid', () => {
        cmp.setProps({
            data: {
                duration: 2,
                start_date: moment().format('YYYY-MM-DD'),
                end_date: moment()
                    .subtract(1, 'days')
                    .format('YYYY-MM-DD'),
            },
        });

        expect(cmp.vm.numberOfDays).toBe(-1);
        expect(cmp.vm.numberOfSprints).toBe(0);
    });

    it('adds days to a date', () => {
        expect(cmp.vm.datePlusDays('2000-01-01', 1)).toBe('2000-01-02');
    });
});
