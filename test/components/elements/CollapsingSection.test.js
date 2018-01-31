
import { mount } from 'vue-test-utils';
import CollapsingSection from '@/components/elements/CollapsingSection';


describe('The collapsing section component', () => {
    let cmp, row, col1, col2;

    beforeAll(() => {
        cmp = mount(CollapsingSection);
        row = cmp.findAll('.row');
        col1 = cmp.findAll('.col-md-3');
        col2 = cmp.findAll('.col-md-9');
    });

    it('is a row with two columns', () => {
        expect(row.length).toBe(1);
        expect(col1.length).toBe(1);
        expect(col2.length).toBe(1);
    });

    it('toggles visibility on click on first column', () => {
        const stub = jest.fn();
        cmp.vm.$on('toggle', stub);
        col1.at(0).trigger('click');
        expect(stub).toHaveBeenCalledWith(true);
    });
});
