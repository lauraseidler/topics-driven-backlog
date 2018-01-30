import { mount, shallow } from 'vue-test-utils';
import StoryItem from '@/components/elements/StoryItem';
import StoryForm from '@/components/forms/StoryForm';
import '@/directives/confirm';


describe('StoryItem.test.js', () => {
    let cmp, simpleCmp, dispatch = jest.fn(), commit = jest.fn();

    const mocks = {
        $store: {
            state: {
                stories: {
                    statusMap: [{ name: 'open', css: 'badge-dark' }],
                },
            },
            dispatch,
            commit,
            getters: {
                'projects/byId': () => {
                    return {
                        id: 1,
                    };
                },
                'sprints/next': () => {
                    return {
                        id: 1,
                    };
                },
                'topics/byId': () => {
                    return {
                        id: 1,
                    };
                },
                'sprints/all': () => [{
                    name: 'Sprint',
                    topic_ids: [1],
                }],
                'topics/all': () => [],
            },
        },
        $style: {},
    };

    beforeEach(() => {
        cmp = mount(StoryItem, {
            propsData: {
                data: {
                    identifier: 'S-001',
                    title: 'Test story',
                    points: 5,
                    status: 0,
                },
                view: 'backlog',
                position: 1,
                sortable: true,
            },
            mocks,
        });

        simpleCmp = shallow(StoryItem, {
            propsData: {
                data: {
                    identifier: 'S-001',
                    title: 'Test story',
                    points: 5,
                    status: 0,
                },
                view: 'backlog',
            },
            mocks,
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
        expect(commit).toHaveBeenCalledWith('newPendingChange');
    });

    it('resolves pending change on cancel', () => {
        cmp.vm.cancelEdit();
        expect(commit).toHaveBeenCalledWith('resolvePendingChange');
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

        expect(dispatch).toBeCalled();
        expect(cmp.vm.editing).toBe(false);
    });

    it('patches the story status correctly', () => {
        cmp.vm.saveStatus(1);

        expect(dispatch).toBeCalled();
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
        expect(dispatch).toHaveBeenCalled();
    });

    it('dispatches addToSprint action', () => {
        const props = cmp.props;
        props.view = 'planning-backlog';
        cmp.setProps(props);

        cmp.find('.btn-outline-primary').trigger('click');
        expect(dispatch).toHaveBeenCalled();
    });

    it('dispatches removeFromSprint action', () => {
        const props = cmp.props;
        props.view = 'planning-sprint';
        cmp.setProps(props);

        cmp.find('.btn-outline-primary').trigger('click');
        expect(dispatch).toHaveBeenCalled();
    });

    it('starts keyboard edit on double click', () => {
        const handler = cmp.findAll('.js-drag-drop');
        expect(handler.length).toBe(1);
        handler.at(0).trigger('dblclick');
        expect(cmp.vm.keyboardSorting).toBe(true);
    });

    it('stops keyboard sort when enter key is pressed', () => {
        const stub = jest.fn();
        cmp.vm.$on('moveComplete', stub);
        cmp.update();

        cmp.vm.startKeyboardSort();
        cmp.vm.move({ keyCode: 13, preventDefault: stub });
        expect(cmp.vm.keyboardSorting).toBe(false);
        expect(stub).toHaveBeenCalledTimes(2);
    });

    it('aborts keyboard sort when esc key is pressed', () => {
        const stub = jest.fn();
        cmp.vm.$on('moveAbort', stub);
        cmp.update();

        cmp.vm.startKeyboardSort();
        cmp.vm.move({ keyCode: 27, preventDefault: stub });
        expect(cmp.vm.keyboardSorting).toBe(false);
        expect(stub).toHaveBeenCalledTimes(2);
    });

    it('emits move event when arrow up key is pressed', () => {
        const stub = jest.fn();
        cmp.vm.$on('move', stub);
        cmp.update();

        cmp.vm.startKeyboardSort();
        cmp.vm.move({ keyCode: 38, preventDefault: stub });
        expect(stub).toHaveBeenCalledTimes(2);
        expect(stub).toHaveBeenCalledWith(undefined, -1);
    });

    it('emits move event when arrow down key is pressed', () => {
        const stub = jest.fn();
        cmp.vm.$on('move', stub);
        cmp.update();

        cmp.vm.startKeyboardSort();
        cmp.vm.move({ keyCode: 40, preventDefault: stub });
        expect(stub).toHaveBeenCalledTimes(2);
        expect(stub).toHaveBeenCalledWith(undefined, 1);
    });

    it('does nothing when keys are pressed when keyboard sorting is off', () => {
        const stub = jest.fn();
        cmp.vm.$on('move', stub);
        cmp.vm.$on('moveComplete', stub);
        cmp.vm.$on('moveAbort', stub);
        cmp.update();

        cmp.vm.move({ keyCode: 13, preventDefault: stub });
        cmp.vm.move({ keyCode: 27, preventDefault: stub });
        cmp.vm.move({ keyCode: 38, preventDefault: stub });
        cmp.vm.move({ keyCode: 40, preventDefault: stub });

        expect(stub).not.toHaveBeenCalled();    
    });

    it('shows backlog page', () => {
        expect(simpleCmp.findAll('td').length).toBe(6);
    });

    it('shows history page', () => {
        const props = simpleCmp.props;
        props.view = 'history';
        simpleCmp.setProps(props);

        expect(simpleCmp.findAll('td').length).toBe(6);
    });

    it('shows planning-sprint page', () => {
        const props = simpleCmp.props;
        props.view = 'planning-sprint';
        simpleCmp.setProps(props);

        expect(simpleCmp.findAll('td').length).toBe(6);
    });

    it('shows planning-backlog page', () => {
        const props = simpleCmp.props;
        props.view = 'planning-backlog';
        simpleCmp.setProps(props);

        expect(simpleCmp.findAll('td').length).toBe(6);
    });

    it('shows sprint page', () => {
        const props = simpleCmp.props;
        props.view = 'sprint';
        simpleCmp.setProps(props);

        expect(simpleCmp.findAll('td').length).toBe(6);
    });
});
