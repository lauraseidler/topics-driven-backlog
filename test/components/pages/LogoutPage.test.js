import { mount } from 'vue-test-utils';
import LogoutPage from '@/components/pages/LogoutPage';

describe('The LogoutPage component', () => {
    let cmp, commit = jest.fn();

    beforeAll(() => {
        cmp = mount(LogoutPage, {
            mocks: {
                $router: [],
                $store: {
                    commit,
                },
            },
        });

        jest.resetAllMocks();
    });

    it('logs the user out', () => {
        cmp.vm.logout();
        expect(commit).toHaveBeenCalled();
        expect(cmp.vm.$router[0]).toBe('/');
    });
});