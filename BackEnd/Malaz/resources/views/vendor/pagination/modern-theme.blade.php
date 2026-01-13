{{-- resources/views/vendor/pagination/modern-theme.blade.php --}}

@if ($paginator->hasPages())
    <nav role="navigation" aria-label="Pagination Navigation" class="flex items-center justify-between">
        {{-- Previous Page Link --}}
        <div class="flex justify-start">
            @if ($paginator->onFirstPage())
                <span class="relative inline-flex items-center px-4 py-2 text-sm font-medium text-sandstone bg-white/80 rounded-lg cursor-default">
                    &laquo; Previous
                </span>
            @else
                <a href="{{ $paginator->previousPageUrl() }}" rel="prev" class="relative inline-flex items-center px-4 py-2 text-sm font-medium text-walnut bg-white rounded-lg border border-sandstone/30 hover:bg-cream transition-colors">
                    &laquo; Previous
                </a>
            @endif
        </div>

        {{-- Pagination Elements --}}
        <div class="hidden sm:flex">
            @foreach ($elements as $element)
                {{-- "Three Dots" Separator --}}
                @if (is_string($element))
                    <span class="relative inline-flex items-center px-4 py-2 text-sm font-medium text-forest/60 bg-white cursor-default">{{ $element }}</span>
                @endif

                {{-- Array Of Links --}}
                @if (is_array($element))
                    @foreach ($element as $page => $url)
                        @if ($page == $paginator->currentPage())
                            <span class="relative inline-flex items-center px-4 py-2 text-sm font-bold text-white bg-ochre rounded-lg shadow-sm cursor-default">{{ $page }}</span>
                        @else
                            <a href="{{ $url }}" class="relative inline-flex items-center px-4 py-2 text-sm font-medium text-walnut bg-white rounded-lg hover:bg-cream transition-colors">{{ $page }}</a>
                        @endif
                    @endforeach
                @endif
            @endforeach
        </div>

        {{-- Next Page Link --}}
        <div class="flex justify-end">
            @if ($paginator->hasMorePages())
                <a href="{{ $paginator->nextPageUrl() }}" rel="next" class="relative inline-flex items-center px-4 py-2 text-sm font-medium text-walnut bg-white rounded-lg border border-sandstone/30 hover:bg-cream transition-colors">
                    Next &raquo;
                </a>
            @else
                <span class="relative inline-flex items-center px-4 py-2 text-sm font-medium text-sandstone bg-white/80 rounded-lg cursor-default">
                    Next &raquo;
                </span>
            @endif
        </div>
    </nav>
@endif
