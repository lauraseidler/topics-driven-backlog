import { mount } from 'vue-test-utils';
import StoryTable from '@/components/elements/StoryTable';
import { setTimeout } from 'timers';


describe('The StoryTable component', () => {
    let cmp, dispatch = jest.fn(), ths;

    const mocks = {
        $store: {
            state: {
                stories: {
                    statusMap: [{ name: 'open', css: 'badge-dark' }],
                },
            },
            dispatch,
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

    beforeAll(() => {
        cmp = mount(StoryTable, {
            propsData: {
                columns: [
                    { field: 'id', name: 'ID' },
                    { field: 'test', name: 'Test' },
                ],
                rows: [
                    { id: 1, test: 'ba' },
                    { id: 2, test: 'ab' },
                ],
                positionField: 'id',
            },
            mocks,
        });
    });
    
    it('is a striped table', () => {
        expect(cmp.is('table.story-table.table-striped')).toBe(true);
    });

    it('correctly sorts by fields', () => {
        ths = cmp.findAll('th');
        expect(ths.length).toBe(2);

        ths.at(1).trigger('click');

        expect(cmp.vm.currentSort.field).toBe('test');
        expect(cmp.vm.currentSort.order).toBe(1);
        expect(cmp.vm.sortedRows).toEqual([
            { id: 2, test: 'ab' },
            { id: 1, test: 'ba' },
        ]);

        ths.at(1).trigger('click');

        expect(cmp.vm.currentSort.field).toBe('test');
        expect(cmp.vm.currentSort.order).toBe(-1);
        expect(cmp.vm.sortedRows).toEqual([
            { id: 1, test: 'ba' },
            { id: 2, test: 'ab' },
        ]);

        ths.at(1).trigger('click');

        expect(cmp.vm.currentSort.field).toBe('id');
        expect(cmp.vm.currentSort.order).toBe(1);
        expect(cmp.vm.sortedRows).toEqual([
            { id: 1, test: 'ba' },
            { id: 2, test: 'ab' },
        ]);

        ths.at(0).trigger('click');

        expect(cmp.vm.currentSort.field).toBe('id');
        expect(cmp.vm.currentSort.order).toBe(-1);
        expect(cmp.vm.sortedRows).toEqual([
            { id: 2, test: 'ab' },
            { id: 1, test: 'ba' },
        ]);
    });

    it('moves stories up/down when move events are triggered', () => {
        cmp.vm.resetSort();

        cmp.vm.move('1', 1);
        
        expect(cmp.vm.moving[1]).toBe(1);

        expect(cmp.vm.sortedRows).toEqual([
            { id: 1, test: 'ba' },
            { id: 2, test: 'ab' },
        ]);

        expect(cmp.vm.sortedAndMovedRows).toEqual([
            { id: 2, test: 'ab' },
            { id: 3, test: 'ba' },
        ]);
    });

    it('doesnt move story further if already at the end', () => {
        cmp.vm.moveStart(2);
        expect(cmp.vm.moving[2]).toBe(0);

        cmp.vm.move('2', -1);
        
        expect(cmp.vm.moving[2]).toBe(0);

        expect(cmp.vm.sortedRows).toEqual([
            { id: 1, test: 'ba' },
            { id: 2, test: 'ab' },
        ]);

        expect(cmp.vm.sortedAndMovedRows).toEqual([
            { id: 2, test: 'ab' },
            { id: 3, test: 'ba' },
        ]);
    });

    it('aborts move and resets', () => {
        cmp.vm.moveAbort(1);
        expect(cmp.vm.moving[1]).toBeUndefined();

        expect(cmp.vm.sortedAndMovedRows).toEqual([
            { id: 1, test: 'ba' },
            { id: 2, test: 'ab' },
        ]);
    });

    it('dispatches actions to save order and highlights story', async () => {
        jest.useFakeTimers();

        await cmp.vm.moveComplete(2);
        expect(cmp.vm.highlight).toBe(2);
        expect(dispatch).toHaveBeenCalledTimes(2);

        jest.runAllTimers();
        expect(cmp.vm.highlight).toBeNull();
    });

    it('also works with empty rows and columns', () => {
        cmp = mount(StoryTable, {
            mocks,
        });

        expect(cmp.vm.rows).toEqual([]);
        expect(cmp.vm.columns).toEqual([]);
    });

    it('doesnt have sort functionality in print view', () => {
        cmp = mount(StoryTable, {
            propsData: {
                view: 'print',
            },
            mocks,
        });

        cmp.vm.sortBy('id');
        expect(cmp.vm.currentSort.field).toBeNull();
    });
});
