import { createLocalVue, mount } from 'vue-test-utils';
import Vuex from 'vuex';
import App from '@/components/App';
import bus from '@/helper/bus';


const localVue = createLocalVue();
localVue.use(Vuex);

describe('The app component', () => {
    let cmp, saveAllButton;

    beforeEach(() => {
        cmp = mount(App, {
            localVue,
            store: new Vuex.Store({
                state: {
                    pendingChanges: 1,
                },
            }),
        });
    });

    it('is a div with id app', () => {
        expect(cmp.is('div#app')).toBe(true);
    });

    it('shows save all button when there are pending changes', () => {
        saveAllButton = cmp.findAll('.btn').at(0);
        expect(saveAllButton.text()).toBe('Save all');
    });

    it('emits save all event to bus when save all button is clicked', () => {
        const stub = jest.fn();
        bus.$on('saveAll', stub);
        saveAllButton.trigger('click');
        expect(stub).toHaveBeenCalled();
    });

    it('has an area to display the current router view', () => {
        expect(cmp.findAll('router-view').length).toBe(1);
    });

    it('has an area to display notifications', () => {
        expect(cmp.findAll('notifications').length).toBe(1);
    });
});
