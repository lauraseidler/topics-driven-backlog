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
        jest
            .spyOn(cmp.vm.$store, 'dispatch')
            .mockImplementation(() => Promise.resolve(true));
    });

    it('has initialised the router', async () => {
        expect(cmp.vm.$router).toBeTruthy();
        expect(cmp.vm.$route).toBeTruthy();
        await cmp.vm.$router.push('/login');
        expect(cmp.vm.$route.path).toBe('/login');

    });

    it('asks to confirm when navigating with pending changes', async () => {
        cmp.vm.$store.state.loggedIn = true;

        await cmp.vm.$router.push('/projects');

        const confirmSpy = jest
            .spyOn(window, 'confirm')
            .mockImplementation(() => true);

        cmp.vm.$store.commit('newPendingChange');
        await cmp.vm.$router.push('/courses');
        expect(confirmSpy).toHaveBeenCalled();
        expect(cmp.vm.$route.path).toBe('/courses');
    });

    it('does not navigate if not confirmed', async () => {
        cmp.vm.$store.state.loggedIn = true;
        await cmp.vm.$router.push('/projects');

        const confirmSpy = jest
            .spyOn(window, 'confirm')
            .mockImplementation(() => false);

        cmp.vm.$store.commit('newPendingChange');
        await cmp.vm.$router.push('/courses');
        expect(confirmSpy).toHaveBeenCalled();
        expect(cmp.vm.$route.path).toBe('/projects');
    });

    it('dispatches the courses/init action on route change when logged in', async () => {
        cmp.vm.$store.state.loggedIn = true;
        await cmp.vm.$router.push('/');
        await cmp.vm.$router.push('/projects');
        await cmp.vm.$router.push('/courses');
        expect(cmp.vm.$store.dispatch).toHaveBeenCalledWith('courses/init', {});
        expect(cmp.vm.$store.dispatch).toHaveBeenCalledTimes(3);
    });
});
