import { createLocalVue, mount } from 'vue-test-utils';
import router from '@/router';
import store from '@/store';

const localVue = createLocalVue();

describe('The router', () => {
    let cmp;

    beforeEach(() => {
        cmp = (mount({
            localVue,
            router,
            store,
        }));
    });

    it('has initialised the router', () => {
        expect(cmp.vm.$router).toBeTruthy();
        expect(cmp.vm.$route).toBeTruthy();
    });

    it('asks to confirm when navigating with pending changes', () => {
        cmp.vm.$store.state.loggedIn = true;
        cmp.vm.$router.push('/projects');

        const confirmSpy = jest
            .spyOn(window, 'confirm')
            .mockImplementation(() => true);

        cmp.vm.$store.commit('newPendingChange');
        cmp.vm.$router.push('/courses');
        expect(confirmSpy).toHaveBeenCalled();
        expect(cmp.vm.$route.path).toBe('/courses');
    });

    it('does not navigate if not confirmed', () => {
        cmp.vm.$store.state.loggedIn = true;
        cmp.vm.$router.push('/projects');

        const confirmSpy = jest
            .spyOn(window, 'confirm')
            .mockImplementation(() => false);

        cmp.vm.$store.commit('newPendingChange');
        cmp.vm.$router.push('/courses');
        expect(confirmSpy).toHaveBeenCalled();
        expect(cmp.vm.$route.path).toBe('/projects');
    });
});