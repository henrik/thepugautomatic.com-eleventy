@interface NSManagedObjectContext (UpdateEntity)
- (void)updateEntity:(NSString *)entity fromDictionary:(NSDictionary *)importDict withIdentifier:(NSString *)identifier overwriting:(NSArray *)overwritables andError:(NSError **)error;
@end

@implementation NSManagedObjectContext (UpdateEntity)

/*
	Expects an import dictionary like
	{"some.channel.se" => {"displayName" => "Some Channel", "baseURL" => "http://www.example.com/"}}.
*/

- (void)updateEntity:(NSString *)entity fromDictionary:(NSDictionary *)importDict withIdentifier:(NSString *)identifier overwriting:(NSArray *)overwritables andError:(NSError **)error {

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
		if (!thisImportIdentifier) {  // If the import list has run out, the import identifier sorts last (i.e. remove remaining objects)
			comparison = NSOrderedDescending;
		} else if (!thisObject) {  // If managed object list has run out, the import identifier sorts first (i.e. add remaining objects)
			comparison = NSOrderedAscending;
		} else {  // If neither list has run out, compare with the object 
			comparison = [thisImportIdentifier compare:[thisObject valueForKey:identifier]];
		}
		
		if (comparison == NSOrderedSame) {  // Identifiers match
			
			if (overwritables) {  // Merge the allowed non-identifier properties, if not nil
				NSDictionary *importAttributes = [importDict objectForKey:thisImportIdentifier];
				NSDictionary *overwriteAttributes = [NSDictionary dictionaryWithObjects:[importAttributes objectsForKeys:overwritables notFoundMarker:@""] forKeys:overwritables];

				[thisObject setValuesForKeysWithDictionary:overwriteAttributes]; 
			}
			
			// Move ahead in both lists
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