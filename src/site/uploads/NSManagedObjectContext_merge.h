@interface NSManagedObjectContext (Merge)
- (void)updateEntity:(NSString *)entity fromDictionary:(NSDictionary *)importDict withIdentifier:(NSString *)identifier andError:(NSError **)error;
@end

@implementation NSManagedObjectContext (Merge)

/*
	Expects an import dictionary like
	{"some.channel.se" => {"displayName" => "Some Channel", "baseURL" => "http://www.example.com/"}}.
*/

- (void)updateEntity:(NSString *)entity fromDictionary:(NSDictionary *)importDict withIdentifier:(NSString *)identifier andError:(NSError **)error {

	// Get the sorted import identifiers
	NSArray *identifiersToImport = [[importDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
	
	// Get the entities as managed objects
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:self]];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:identifier ascending:YES] autorelease]]];
	
	NSArray *managedObjects = [self executeFetchRequest:fetchRequest error:error];
	[fetchRequest release];
	
	// Compare import identifiers with managed object identifiers
	
	NSEnumerator* importIterator = [identifiersToImport objectEnumerator];
	NSEnumerator* objectIterator = [managedObjects objectEnumerator];
	NSString *thisImportIdentifier = [importIterator nextObject];
	NSManagedObject *thisObject = [objectIterator nextObject];

	// Loop through both lists, comparing identifiers, until both are empty
	while (thisImportIdentifier || thisObject) {
	
		// Compare identifiers 
		NSComparisonResult comparison;
		if (thisObject) {  // If the list of managed objects hasn't run out, compare with the object 
			comparison = [thisImportIdentifier compare:[thisObject valueForKey:identifier]];
		} else {
			comparison = NSOrderedAscending;  // If managed object list has run out, the import identifier sorts first
		}
		
		if (comparison == NSOrderedSame) {  // Identifiers match

			// Merge non-identifier properties and move ahead in both lists

			[thisObject setValuesForKeysWithDictionary:[importDict objectForKey:thisImportIdentifier]];
			thisObject = [objectIterator nextObject];
			thisImportIdentifier = [importIterator nextObject];
		
		} else if (comparison == NSOrderedAscending) {  // Imported item sorts before stored item
		
			// The imported item is previously unseen - add it and move ahead to the next import identifier
			
			NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self];
			[newObject setValue:thisImportIdentifier forKey:identifier];
			[newObject setValuesForKeysWithDictionary:[importDict objectForKey:thisImportIdentifier]];
			thisImportIdentifier = [importIterator nextObject];
			
		} else {  // Imported item sorts after stored item
		
			// The stored item is not among those imported, and should be removed, then move ahead to the next stored item

			[self deleteObject:thisObject];
			thisObject = [objectIterator nextObject];

		}
	}
}

@end