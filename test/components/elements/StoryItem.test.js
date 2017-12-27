import { mount, shallow, createLocalVue } from 'vue-test-utils';
import Vuex from 'vuex';
import Vuelidate from 'vuelidate';
import StoryItem from '@/components/elements/StoryItem';
import StoryForm from '@/components/forms/StoryForm';
import '@/directives/confirm';

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.use(Vuelidate);

describe('StoryItem.test.js', () => {
    let cmp, simpleCmp, actions, store;

    beforeEach(() => {
        actions = {
            patch: jest.fn(),
            delete: jest.fn(),
        };

        store = new Vuex.Store({
            modules: {
                stories: {
                    namespaced: true,
                    state: {
                        statusMap: [{ name: 'open', css: 'badge-dark' }],
                    },
                    actions,
                },
            },
        });

        cmp = mount(StoryItem, {
            localVue,
            store,
            propsData: {
                data: {
                    identifier: 'S-001',
                    title: 'Test story',
                    points: 5,
                    status: 0,
                },
                view: 'backlog',
            },
        });

        simpleCmp = shallow(StoryItem, {
            localVue,
            store,
            propsData: {
                data: {
                    identifier: 'S-001',
                    title: 'Test story',
                    points: 5,
                    status: 0,
                },
                view: 'backlog',
            },
        });
    });

    it('tells us if we are operating in a given view', () => {
        expect(cmp.vm.isView('backlog')).toBe(true);
        expect(cmp.vm.isView('something-else')).toBe(false);
        expect(cmp.vm.isView(['backlog', 'something-else'])).toBe(true);
    });

    it('calls starts editing when edit button is clicked', () => {
        cmp.vm.startEditing = jest.fn();
        cmp.update();

        cmp
            .findAll('.btn')
            .at(0)
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

    it('triggers story save when story form triggers submit', () => {
        cmp.vm.startEditing();
        cmp.vm.save = jest.fn();
        cmp.update();

        cmp.find(StoryForm).trigger('submit');
        expect(cmp.vm.save).toBeCalled();
    });

    it('patches the story and leaves editing mode on story save', () => {
        cmp.vm.save();

        expect(actions.patch).toBeCalled();
        expect(cmp.vm.editing).toBe(false);
    });

    it('patches the story status correctly', () => {
        cmp.vm.saveStatus(1);

        expect(actions.patch).toBeCalled();
        expect(cmp.vm.editing).toBe(false);
    });

    it('deletes the sprint when delete button is clicked', () => {
        const confirmSpy = jest
            .spyOn(window, 'confirm')
            .mockImplementation(() => true);

        cmp
            .findAll('.btn')
            .at(1)
            .trigger('click');

        expect(confirmSpy).toHaveBeenCalled();
        expect(actions.delete).toHaveBeenCalled();
    });

    it('emits addToSprint event to parent', () => {
        const props = cmp.props;
        props.view = 'planning-backlog';
        cmp.setProps(props);

        const stub = jest.fn();
        cmp.vm.$on('addToSprint', stub);

        cmp
            .findAll('.btn')
            .at(1)
            .trigger('click');

        expect(stub).toBeCalled();
    });

    it('emits removeFromSprint event to parent', () => {
        const props = cmp.props;
        props.view = 'planning-sprint';
        cmp.setProps(props);

        const stub = jest.fn();
        cmp.vm.$on('removeFromSprint', stub);

        cmp
            .findAll('.btn')
            .at(0)
            .trigger('click');

        expect(stub).toBeCalled();
    });

    it('shows backlog page', () => {
        expect(simpleCmp.findAll('td').length).toBe(5);
        expect(simpleCmp.element).toMatchSnapshot();
    });

    it('shows history page', () => {
        const props = simpleCmp.props;
        props.view = 'history';
        simpleCmp.setProps(props);

        expect(simpleCmp.findAll('td').length).toBe(4);
        expect(simpleCmp.element).toMatchSnapshot();
    });

    it('shows planning-sprint page', () => {
        const props = simpleCmp.props;
        props.view = 'planning-sprint';
        simpleCmp.setProps(props);

        expect(simpleCmp.findAll('td').length).toBe(5);
        expect(simpleCmp.element).toMatchSnapshot();
    });

    it('shows planning-backlog page', () => {
        const props = simpleCmp.props;
        props.view = 'planning-backlog';
        simpleCmp.setProps(props);

        expect(simpleCmp.findAll('td').length).toBe(4);
        expect(simpleCmp.element).toMatchSnapshot();
    });

    it('shows sprint page', () => {
        const props = simpleCmp.props;
        props.view = 'sprint';
        simpleCmp.setProps(props);

        expect(simpleCmp.findAll('td').length).toBe(4);
        expect(simpleCmp.element).toMatchSnapshot();
    });
});
