import { mount, createLocalVue } from 'vue-test-utils';
import Vuex from 'vuex';
import Vuelidate from 'vuelidate';
import ProjectItem from '@/components/elements/ProjectItem';
import ProjectForm from '@/components/forms/ProjectForm';
import '@/directives/confirm';

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.use(Vuelidate);

describe('ProjectItem.test.js', () => {
    let cmp, actions, store;

    beforeEach(() => {
        actions = {
            patch: jest.fn(),
            delete: jest.fn(),
        };

        store = new Vuex.Store({
            modules: {
                projects: {
                    namespaced: true,
                    actions,
                },
            },
        });

        cmp = mount(ProjectItem, {
            localVue,
            store,
            propsData: {
                data: {
                    id: 1,
                    title: 'Test Project',
                },
            },
        });
    });

    it('shows edit and delete buttons', () => {
        expect(cmp.findAll('.card-body .btn').length).toBe(2);
        expect(cmp.element).toMatchSnapshot();
    });

    it('calls starts editing when edit button is clicked', () => {
        cmp.vm.startEditing = jest.fn();
        cmp.update();

        cmp
            .findAll('.card-body .btn')
            .at(1)
            .trigger('click');

        expect(cmp.vm.startEditing).toBeCalled();
    });

    it('is in edit mode after startEditing was called', () => {
        cmp.vm.startEditing();
        cmp.update();
        expect(cmp.vm.editing).toBe(true);
        expect(cmp.vm.editingData).toBeTruthy();
        expect(cmp.element).toMatchSnapshot();
    });

    it('triggers project save when project form triggers submit', () => {
        cmp.vm.startEditing();
        cmp.vm.saveProject = jest.fn();
        cmp.update();

        cmp.find(ProjectForm).trigger('submit');
        expect(cmp.vm.saveProject).toBeCalled();
    });

    it('patches the project and leaves editing mode on project save', () => {
        cmp.vm.saveProject();

        expect(actions.patch).toBeCalled();
        expect(cmp.vm.editing).toBe(false);
    });

    it('deletes the project when delete button is clicked', () => {
        const confirmSpy = jest
            .spyOn(window, 'confirm')
            .mockImplementation(() => true);

        cmp
            .findAll('.card-body .btn')
            .at(0)
            .trigger('click');

        expect(confirmSpy).toHaveBeenCalled();
        expect(actions.delete).toHaveBeenCalled();
    });
});
