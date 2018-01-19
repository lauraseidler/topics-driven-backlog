import { generate } from '@/store/base/resource-module/index';
import resources from '@/store/resources';

const resourceModule = generate({
    resource: resources.STORIES,
    parent: resources.PROJECTS,
    state: {
        STATUS: { OPEN: 0, IN_PROGRESS: 1, CLOSED: 2, CANCELLED: 3 },
        statusMap: [
            { name: 'open', css: 'badge-dark' },
            { name: 'in progress', css: 'badge-warning' },
            { name: 'closed', css: 'badge-success' },
            { name: 'cancelled', css: 'badge-danger' },
        ],
    },
    template: () => {
        return {
            topic_id: null,
        };
    },
});

export default resourceModule;
