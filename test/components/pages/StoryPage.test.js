import { mount, createLocalVue } from 'vue-test-utils';
import mockRouter from 'mock-vue-router';
import Vuex from 'vuex';
import StoryPage from '@/components/pages/StoryPage';

const localVue = createLocalVue();
localVue.use(Vuex);

const { $router, $route } = mockRouter(['/stories/:identifier'], '/stories/1');

describe('StoryPage.test.js', () => {
    let cmp, store, getters;

    beforeEach(() => {
        getters = {
            byIdentifier: () => id =>
                [
                    { id: 1, title: 'Test story' },
                    { id: 2, title: 'Test story 2' },
                ][id - 1],
        };

        store = new Vuex.Store({
            modules: {
                stories: {
                    namespaced: true,
                    getters,
                },
            },
        });

        cmp = mount(StoryPage, {
            localVue,
            store,
            mocks: {
                $router,
                $route,
            },
        });
    });

    it('returns correct story from route param', () => {
        expect(cmp.vm.story.title).toBe('Test story');
    });

    it('has the expected html structure', () => {
        expect(cmp.element).toMatchSnapshot();
    });
});
