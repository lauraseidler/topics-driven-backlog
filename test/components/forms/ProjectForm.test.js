import { mount, createLocalVue } from 'vue-test-utils';
import Vuelidate from 'vuelidate';
import ProjectForm from '@/components/forms/ProjectForm';


const localVue = createLocalVue();
localVue.use(Vuelidate);

describe('ProjectForm.test.js', () => {
    let cmp;

    beforeEach(() => {
        cmp = mount(ProjectForm, {
            localVue,
            propsData: {
                data: {
                    title: 'Test Project',
                },
            },
        });
    });

    it('has the expected html structure', () => {
        expect(cmp.element).toMatchSnapshot();
    });
});
