import { mount, createLocalVue } from 'vue-test-utils';
import moment from 'moment';
import Vuex from 'vuex';
import Vuelidate from 'vuelidate';
import SprintForm from '@/components/forms/SprintForm';

// take a date far in the future so validations pass
Date.now = jest.fn(() => 7956915742000);

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.use(Vuelidate);

describe('SprintForm.test.js', () => {
    let cmp, store;

    beforeEach(() => {
        store = new Vuex.Store({
            currentDate: moment().format('YYYY-MM-DD'),
        });

        cmp = mount(SprintForm, {
            localVue,
            store,
            propsData: {
                data: {
                    name: 'Test Sprint',
                    start_date: moment().format('YYYY-MM-DD'),
                    end_date: moment().add(5, 'days').format('YYYY-MM-DD'),
                },
            },
        });
    });

    it('has the expected html structure', () => {
        expect(cmp.element).toMatchSnapshot();
    });
});