import { mount, createLocalVue } from 'vue-test-utils';
import Vuelidate from 'vuelidate';
import ProjectForm from '@/components/forms/ProjectForm';


const localVue = createLocalVue();
localVue.use(Vuelidate);

describe('ProjectForm.test.js', () => {
    let cmp;

    beforeAll(() => {
        cmp = mount(ProjectForm, {
            localVue,
            propsData: {
                data: {
                    title: 'Test Project',
                },
            },
        });
    });

    it('is a form with class project-form', () => {
        expect(cmp.is('form.project-form'));
    });
});
