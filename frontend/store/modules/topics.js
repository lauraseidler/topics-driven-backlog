import { generate } from '@/store/base/resource-module/index';
import resources from '@/store/resources';

const resourceModule = generate({
    resource: resources.TOPICS,
    parent: resources.COURSES,
});

export default resourceModule;
