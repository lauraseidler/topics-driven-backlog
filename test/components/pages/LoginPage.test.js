import { mount } from 'vue-test-utils';
import LoginPage from '@/components/pages/LoginPage';

describe('The LoginPage component', () => {
    let cmp, dispatch = jest.fn(), form;

    beforeAll(() => {
        cmp = mount(LoginPage, {
            mocks: {
                $route: {
                    query: { redirectTo: '/projects' },
                },
                $router: [],
                $store: {
                    dispatch,
                },
            },
        });

        jest.resetAllMocks();
    });

    it('renders login form', () => {
        form = cmp.find('.login-form');
        expect(form).toBeTruthy();
    });

    it('dispatches login action and redirects', async () => {
        form.trigger('submit');
        await expect(dispatch).toHaveBeenCalled();
        expect(cmp.vm.$router[0]).toBe('/projects');
    });

    it('redirects to index if no redirect info is set', async () => {
        cmp.vm.$route.query.redirectTo = null;
        cmp.update();

        form.trigger('submit');
        await expect(dispatch).toHaveBeenCalled();
        expect(cmp.vm.$router[1]).toBe('/');
    });
});