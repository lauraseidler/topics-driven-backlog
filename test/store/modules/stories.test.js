// spy on console warnings
jest.spyOn(console, 'info').mockImplementation(text => text);

import storiesModule from '@/store/modules/stories';

describe('The stories module', () => {
    it('returns a correct new template', () => {
        const template = storiesModule.getters.template()();
        expect(template.topic_id).toBeNull();
    });
});