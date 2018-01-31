// spy on console warnings
jest.spyOn(console, 'info').mockImplementation(text => text);

import coursesModule from '@/store/modules/courses';

describe('The courses module', () => {
    it('returns a correct new template', () => {
        const template = coursesModule.getters.template()();
        expect(template.semester).toBeTruthy();
        expect(template.allow_enrollment).toBe(true);
    });
});