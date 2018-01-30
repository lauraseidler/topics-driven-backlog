import { shallow } from 'vue-test-utils';
import PrintPage from '@/components/pages/PrintPage';

describe('The PrintPage component', () => {
    let cmp, dispatch = jest.fn();

    beforeEach(() => {
        cmp = shallow(PrintPage, {
            mocks: {
                $store: {
                    dispatch,
                    getters: {
                        'projects/byId': () => {
                            return {
                                id: 1,
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
                    },
                },
                $route: {
                    params: { id: 1 },
                },
                $style: {},
            },
        });
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

    it('adjusts view if different sprint is chosen', () => {
        cmp.vm.chosenSprint = 1;
        expect(cmp.vm.currentSprint).toBeTruthy();
    });
});