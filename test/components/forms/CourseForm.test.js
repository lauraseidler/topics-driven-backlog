import { mount } from 'vue-test-utils';
import CourseForm from '@/components/forms/CourseForm';


describe('CourseForm.test.js', () => {
    let cmp;

    beforeAll(() => {
        cmp = mount(CourseForm, {
            propsData: {
                data: {
                    title: 'Test Course',
                },
            },
        });
    });

    it('is a form with class course-form', () => {
        expect(cmp.is('form.course-form'));
    });
});
