import { mount } from 'vue-test-utils';
import TopicForm from '@/components/forms/TopicForm';


describe('TopicForm.test.js', () => {
    let cmp;

    beforeAll(() => {
        cmp = mount(TopicForm, {
            propsData: {
                data: {
                    title: 'Test Topic',
                },
            },
        });
    });

    it('is a form with class topic-form', () => {
        expect(cmp.is('form.topic-form'));
    });
});
