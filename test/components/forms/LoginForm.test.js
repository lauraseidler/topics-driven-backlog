import { mount } from 'vue-test-utils';
import LoginForm from '@/components/forms/LoginForm';


describe('LoginForm.test.js', () => {
    let cmp;

    beforeAll(() => {
        cmp = mount(LoginForm, {
            propsData: {
                data: {
                    email: 'user1@example.com',
                },
            },
        });
    });

    it('is a form with class login-form', () => {
        expect(cmp.is('form.login-form'));
    });
});
