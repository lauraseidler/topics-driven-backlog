import { mount, createLocalVue } from 'vue-test-utils';
import Vuelidate from 'vuelidate';
import StoryForm from '@/components/forms/StoryForm';

const localVue = createLocalVue();
localVue.use(Vuelidate);

describe('StoryForm.test.js', () => {
    let cmp;

    beforeEach(() => {
        cmp = mount(StoryForm, {
            localVue,
            propsData: {
                data: {
                    title: 'Test Story',
                    points: 5,
                },
            },
        });
    });

    it('has the expected html structure', () => {
        expect(cmp.element).toMatchSnapshot();
    });
});