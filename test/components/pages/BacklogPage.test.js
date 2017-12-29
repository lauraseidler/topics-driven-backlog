import { mount, createLocalVue } from 'vue-test-utils';
import { state } from '@/store/stories';
import Vuex from 'vuex';
import Vuelidate from 'vuelidate';
import BacklogPage from '@/components/pages/BacklogPage';
import StoryForm from '@/components/forms/StoryForm';

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.use(Vuelidate);

describe('BacklogPage.test.js', () => {
    let cmp, store, actions, getters;

    beforeEach(() => {
        actions = {
            save: jest.fn(),
            patch: jest.fn(),
        };

        getters = {
            all: () => [
                { id: 1, position: 2, status: 0 },
                { id: 2, position: 1, status: 0 },
                { id: 3, position: 3, status: 0, sprint_id: 2 },
                { id: 4, position: 4, status: 1 },
            ],
        };

        store = new Vuex.Store({
            modules: {
                stories: {
                    namespaced: true,
                    state: {
                        STATUS: state.STATUS,
                    },
                    actions,
                    getters,
                },
            },
        });

        cmp = mount(BacklogPage, {
            localVue,
            store,
        });
    });

    it('has sorted stories', () => {
        expect(cmp.vm.stories).toEqual([
            { id: 2, position: 1, status: 0 },
            { id: 1, position: 2, status: 0 },
        ]);
    });

    it('triggers story save when story form triggers submit', () => {
        cmp.vm.showForm = true;
        cmp.vm.newStory = { title: 'Test Story' };
        cmp.vm.save = jest.fn();
        cmp.update();

        cmp.find(StoryForm).trigger('submit');
        expect(cmp.vm.save).toBeCalled();
    });

    it('saves the story on story save', () => {
        cmp.vm.save();

        expect(actions.save).toBeCalled();
        expect(cmp.vm.newStory).toEqual({});
    });

    it('doesnt save the story order if story not found', () => {
        cmp.vm.saveOrder({ oldIndex: 2 });

        expect(actions.patch).not.toBeCalled();
    });

    it('saves the story order on sortable event', () => {
        cmp.vm.saveOrder({ oldIndex: 0, newIndex: 1 });

        expect(actions.patch).toBeCalled();
    });

    it('has the expected html structure', () => {
        expect(cmp.element).toMatchSnapshot();
    });

    it('has the expected html structure when form is displayed', () => {
        cmp.vm.showForm = true;
        cmp.update();

        expect(cmp.element).toMatchSnapshot();
    });
});
