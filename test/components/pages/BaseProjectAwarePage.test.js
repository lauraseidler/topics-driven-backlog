import { mount } from 'vue-test-utils';
import BaseProjectAwarePage from '@/components/pages/BaseProjectAwarePage';

describe('The BaseProjectAwarePage component', () => {
    let cmp, dispatch = jest.fn();

    beforeEach(() => {
        cmp = mount(BaseProjectAwarePage, {
            mocks: {
                $route: {
                    params: { id: 1 },
                },
                $store: {
                    dispatch,
                    getters: {
                        'courses/byId': () => {
                            return {
                                id: 1,
                            };
                        },
                        'projects/byId': () => null,
                    },
                },
            },
        });

        jest.resetAllMocks();
    });

    it('renders text to warn against instantiation', () => {
        expect(cmp.text()).toEqual(expect.stringContaining('can\'t be instantiated!'));
    });

    it('dispatches projects/init', () => {
        cmp.vm.$store.getters['projects/byId'] = () => {
            return {
                id: 1,
            };
        };

        cmp.update();

        expect(dispatch).toHaveBeenCalled();
    });

    it('doesnt dispatch anything if project not found', () => {
        expect(cmp.vm.course).toBeNull();
        expect(dispatch).not.toHaveBeenCalled();
    });
});