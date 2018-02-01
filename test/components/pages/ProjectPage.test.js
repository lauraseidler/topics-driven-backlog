import { shallow } from 'vue-test-utils';
import ProjectPage from '@/components/pages/ProjectPage';

describe('The ProjectPage component', () => {
    let cmp, dispatch = jest.fn(), commit = jest.fn();

    beforeEach(() => {
        cmp = shallow(ProjectPage, {
            mocks: {
                $store: {
                    dispatch,
                    commit,
                    getters: {
                        'projects/byId': () => {
                            return {
                                id: 1,
                                permissions: {
                                    stories: {
                                        read: true,
                                        create: true,
                                    },
                                },
                            };
                        },
                        'courses/byId': () => {
                            return {
                                id: 1,
                            };
                        },
                        'sprints/byId': () => {
                            return {
                                id: 1,
                            };
                        },
                        'sprints/past': () => [
                            { id: 1 },
                            { id: 2 },
                        ],
                        'sprints/current': () => null,
                        'sprints/next': () => null,
                        'stories/all': () => [
                            { id: 1 },
                            { id: 2 },
                        ],
                        'stories/find': () => [
                            { id: 1 },
                            { id: 2 },
                        ],
                        'stories/template': () => {
                            return {
                                title: '',
                            };
                        },
                        'topics/all': () => [
                            { id: 1, title: 'Test topic' },
                            { id: 2, title: 'Test topic 2' },
                        ],
                    },
                },
                $route: {
                    params: { id: 1 },
                },
                $style: {},
            },
        });

        jest.resetAllMocks();
    });

    it('nulls stuff when project not found', () => {
        cmp.vm.$store.getters['projects/byId'] = () => null;
        cmp.update();

        expect(cmp.vm.course).toBeNull();
        expect(cmp.vm.backlog.length).toBe(0);
        expect(cmp.vm.pastSprints.length).toBe(0);
        expect(cmp.vm.currentSprint).toBeNull();
        expect(cmp.vm.nextSprint).toBeNull();
    });

    it('calculates the correct view string depending on sections', () => {
        expect(cmp.vm.currentView).toBe('Backlog');

        cmp.vm.sections.nextSprint = true;
        expect(cmp.vm.currentView).toBe('Sprint planning');

        cmp.vm.sections.history = true;
        expect(cmp.vm.currentView).toBe('History');
    });

    it('commits start and cancel of story create/edit correctly', () => {
        cmp.vm.startNew();
        expect(cmp.vm.showForm).toBe(true);
        expect(commit).toHaveBeenCalledWith('newPendingChange');

        cmp.vm.cancelNew();
        expect(cmp.vm.showForm).toBe(false);
        expect(commit).toHaveBeenCalledWith('resolvePendingChange');
    });

    it('resolves pending change after save', async () => {
        await cmp.vm.save();
        expect(dispatch).toHaveBeenCalled();
        expect(commit).toHaveBeenCalledWith('resolvePendingChange');
        expect(cmp.vm.showForm).toBe(false);
    });

    it('resolves topic ids correctly', () => {
        const story = cmp.vm.resolveTopicId({ title: 'Test story', topic_id: 2 });
        expect(story).toEqual({
            title: 'Test story',
            topic_id: 2,
            topic: 'Test topic 2',
        });
    });
});